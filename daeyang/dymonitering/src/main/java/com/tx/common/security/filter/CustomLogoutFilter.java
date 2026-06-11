package com.tx.common.security.filter;


import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.security.web.util.UrlUtils;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.util.Assert;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.GenericFilterBean;

/**
 * Logs a principal out.
 * <p>
 * Polls a series of {@link LogoutHandler}s. The handlers should be specified in the order they are required.
 * Generally you will want to call logout handlers <code>TokenBasedRememberMeServices</code> and
 * <code>SecurityContextLogoutHandler</code> (in that order).
 * <p>
 * After logout, a redirect will be performed to the URL determined by either the configured
 * <tt>LogoutSuccessHandler</tt> or the <tt>logoutSuccessUrl</tt>, depending on which constructor was used.
 *
 * @author Ben Alex
 */
public class CustomLogoutFilter extends GenericFilterBean {

    //~ Instance fields ================================================================================================

    private String filterProcessesUrl;
    private RequestMatcher logoutRequestMatcher;

    private final List<LogoutHandler> handlers;
    
    private String logoutSuccessUrl = "/";
    
    //~ Constructors ===================================================================================================

    public CustomLogoutFilter(String _logoutSuccessUrl, String logoutUrl, LogoutHandler... handlers) {
        this.handlers = Arrays.asList(handlers);
        logoutSuccessUrl = _logoutSuccessUrl;
        filterProcessesUrl = logoutUrl;
        this.logoutRequestMatcher = new FilterProcessUrlRequestMatcher(filterProcessesUrl);
    }

    //~ Methods ========================================================================================================

    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        String tiles = (String)((HttpServletRequest) request).getSession().getAttribute("currentTiles");
        
        if (requiresLogout(request, response)) {
            Authentication auth = SecurityContextHolder.getContext().getAuthentication();

            if (logger.isDebugEnabled()) {
                logger.debug("Logging out user '" + auth + "' and transferring to logout destination");
            }

            for (LogoutHandler handler : handlers) {
                handler.logout(request, response, auth);
            }
    		
            String _logoutSuccessUrl = logoutSuccessUrl;
    		if("/".equals(_logoutSuccessUrl) && !StringUtils.isEmpty(tiles)){
    			_logoutSuccessUrl = "/"+tiles+"/index.do";
    		}
    		
            
            SimpleUrlLogoutSuccessHandler urlLogoutSuccessHandler = new SimpleUrlLogoutSuccessHandler();
            urlLogoutSuccessHandler.setDefaultTargetUrl(_logoutSuccessUrl);
            urlLogoutSuccessHandler.onLogoutSuccess(request, response, auth);

            return;
        }

        chain.doFilter(request, response);
    }

    /**
     * Allow subclasses to modify when a logout should take place.
     *
     * @param request the request
     * @param response the response
     *
     * @return <code>true</code> if logout should occur, <code>false</code> otherwise
     */
    protected boolean requiresLogout(HttpServletRequest request, HttpServletResponse response) {
        return logoutRequestMatcher.matches(request);
    }

    public void setLogoutRequestMatcher(RequestMatcher logoutRequestMatcher) {
        Assert.notNull(logoutRequestMatcher, "logoutRequestMatcher cannot be null");
        this.logoutRequestMatcher = logoutRequestMatcher;
        this.filterProcessesUrl = null;
    }

    private static final class FilterProcessUrlRequestMatcher implements RequestMatcher {
        private final String filterProcessesUrl;

        private FilterProcessUrlRequestMatcher(String filterProcessesUrl) {
            Assert.hasLength(filterProcessesUrl, "filterProcessesUrl must be specified");
            Assert.isTrue(UrlUtils.isValidRedirectUrl(filterProcessesUrl), filterProcessesUrl + " isn't a valid redirect URL");
            this.filterProcessesUrl = filterProcessesUrl;
        }

        public boolean matches(HttpServletRequest request) {
            String uri = request.getRequestURI();
            int pathParamIndex = uri.indexOf(';');

            if (pathParamIndex > 0) {
                // strip everything from the first semi-colon
                uri = uri.substring(0, pathParamIndex);
            }

            int queryParamIndex = uri.indexOf('?');

            if (queryParamIndex > 0) {
                // strip everything from the first question mark
                uri = uri.substring(0, queryParamIndex);
            }

            if ("".equals(request.getContextPath())) {
                return uri.endsWith(filterProcessesUrl);
            }

            return uri.endsWith(request.getContextPath() + filterProcessesUrl);
        }
    }
}

