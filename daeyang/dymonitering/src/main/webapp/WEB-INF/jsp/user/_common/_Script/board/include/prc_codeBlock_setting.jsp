<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>

<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote-lite.css" rel="stylesheet"> 
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.12/summernote-lite.js"></script>

<!-- include summernote-ko-KR -->
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>
<link rel="stylesheet" href="http://cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet">

<%@ include file="/WEB-INF/jsp/dyAdmin/include/CodeMirror_Include.jsp" %>


<style>

pre > code { background-color: #f6f7f8; width: 100%; }
#addCode { position: absolute; right: 15px; }
#addCodeData { display: none; position: absolute; top: 1120px; right: 413px; z-index:100; }
#codeCategory { display: none; position: absolute; width: 110px; top: 1120px; right: 520px; z-index:100; }
.find-popup-wrap {margin-right: 130px !important; margin-top: 4px;}
.find-popup-wrap .popup-close { position: absolute; top: 20px; right: 20px; z-index: 101; }
.find-popup-wrap .popup-close i { font-size: 30px; }
.CodeMirror-scroll { width: 692px; height: 357px; padding-left: 40px; border: 1px solid rgb(204, 204, 204); }
.CodeMirror { position: relative; overflow: hidden; background: white; border: solid 1px #a9a9a9; height: 357px; min-width: 260px; z-index: 100;}
.find-popup-wrap { display: none; margin-bottom: 92px; margin-right: 447px; position: absolute; top:808px; right:261px; }
.BN_CONTENTS{ width:100%; height:400px; max-width:920px; min-width:260px; padding:10px; overflow-y:auto; }
.fa-file-code-o{ margin-right: 2px; }
.note-mybutton{ float:right; }
.note-editor .note-editing-area p { margin: 0 0 10px; word-break: break-all; white-space: pre-wrap; }
.CodeMirror-linenumbers {width:1px !important; }
.CodeMirror-gutter-elt { width:33px !important; }
.CodeMirror-gutter-wrapper { left:-41px !important; }

@media screen and (max-width: 500px) {
	#addCodeData  { right: 35px; top: 1500px; }
	#codeCategory { right: 132px; top: 1500px; }
	.find-popup-wrap { margin-right: 127px !important; top: 1185px; right: -107px; }
	.CodeMirror-scroll { width: 306px; }
	.waring_box { top: 700px; right: 34px; max-width: 280px; }	 
}

</style>

<script>

//jQuery Dispatch Event Handler At The Beginning
(function($) {
    $.fn.bindFirst = function(/*String*/ eventType, /*[Object])*/ eventData, /*Function*/ handler) {
        var indexOfDot = eventType.indexOf(".");
        var eventNameSpace = indexOfDot > 0 ? eventType.substring(indexOfDot) : "";

        eventType = indexOfDot > 0 ? eventType.substring(0, indexOfDot) : eventType;
        handler = handler == undefined ? eventData : handler;
        eventData = typeof eventData == "function" ? {} : eventData;

        return this.each(function() {
            var $this = $(this);
            var currentAttrListener = this["on" + eventType];

            if (currentAttrListener) {
                $this.bind(eventType, function(e) {
                    return currentAttrListener(e.originalEvent);
                });

                this["on" + eventType] = null;
            }

            $this.bind(eventType + eventNameSpace, eventData, handler);

            var allEvents = $this.data("events") || $._data($this[0], "events");
            var typeEvents = allEvents[eventType];
            var newEvent = typeEvents.pop();
            typeEvents.unshift(newEvent);
        });
    };
})(jQuery);

$(document).ready(function() {
	
	// 코드 입력부분 코드미러 적용
	$(function(){
		editor = codeMirror('htmlmixed','codeContents');
	});

	// summernote 코드추가 버튼 활성화
	  var addCodeButton = function (context) {
		  var ui = $.summernote.ui;
         // create button
	      var button = ui.button({
	          contents: '<i class="fa fa-file-code-o"></i> 코드',
	          tooltip: '코드 추가',
	          click: function () {	 	        	  
	        	layer_popup('#codePopup');	     	        	
	    	}
	  });
	  return button.render();
	 }      
	
	// 코드 추가 이벤트
	  $('#addCodeData').click(function() {
 		 $('#BN_CONTENTS').summernote('editor.restoreRange');
          $('#BN_CONTENTS').summernote('editor.focus');	                 
	       	  var codeCategory = $('#codeCategory option:selected').val();		    	  	  
     	  if(editor.getValue() != ""){
 	 		 var codeContent = editor.getValue();
 	 		 codeContent = codeContent.replaceAll("&","&amp;").replaceAll(">","&gt;").replaceAll("<","&lt;").replaceAll("\n", "<br>");

       		 $('#BN_CONTENTS').summernote('editor.pasteHTML', '<pre><code class="'+codeCategory+'">'+codeContent+'</code></pre>');	              	
     	  }
     	  pf_layerClose();
 	 });
	  
	// textarea summernote 에디터 적용
    $('#BN_CONTENTS').summernote({
    	height: 300,                					 // 에디터 높이
		minHeight: null,             					 // 최소 높이
		maxHeight: null,             					 // 최대 높이
		focus: true,                  					 // 에디터 로딩후 포커스를 맞출지 여부
		lang: "ko-KR",									 // 한글 설정
	    placeholder: '내용을 입력해 주세요.', // set editable area's placeholder text
	    toolbar: [
			['style', ['style']],
			['font', ['bold', 'italic', 'underline', 'clear']],
			['para', ['ul', 'ol']],
			['height', ['height']],
			['insert', ['link']],
			['view', ['fullscreen', 'codeview']],
			['help', ['help']],
            ['mybutton', ['addCode']]
		],         
        buttons: {
        	addCode: addCodeButton
        },
        callbacks: {
            onInit: function () {
                // XSS Vulnerability Protection (frontend side)
                $('.btn-codeview').bindFirst('click', function () {
                    var filter = /<\/*(?:applet|b(?:ase|gsound|link)|embed|frame(?:set)?|i(?:frame|layer)|l(?:ayer|ink)|meta|object|s(?:cript|tyle)|title|xml)[^>]*?>/gi;
                    var codable = $('textarea.note-codable');
                    var replaced = codable.val().replace(filter, '');
                    codable.val(replaced);
                });
            }
        }
    
    });
});

//레이어팝업 열기
function layer_popup(el){

var $el = $(el);        //레이어의 id를 $el 변수에 저장
$el.fadeIn();

var $elWidth = ~~($el.width()),
    $elHeight = ~~($el.height()),
    docWidth = $(document).width(),
    docHeight = $(document).height();

// 화면의 중앙에 레이어를 띄운다.
if ($elHeight < docHeight || $elWidth < docWidth) {
    $el.css({
        marginBottom: $elHeight/2, 
        marginRight: $elWidth/2 - 190
    })
} else {
    $el.css({top: 0, left: 0});
}

$el.find('input[type=textarea]').eq(0).focus();

$('#addCodeData').fadeIn();
$('#codeCategory').fadeIn();

}

//레이어팝업 닫기
function pf_layerClose(){
	var inputText = $('#codePopup').find('input[type="textarea"]');
	$.each(inputText,function(i){
		this.value = null;
	})
	$('#searchResult').parent('div').hide();
	$('#codePopup').fadeOut();
	$('#addCodeData').fadeOut();
	$('#codeCategory').fadeOut();
}

</script>
		<div class="find-popup-wrap" id="codePopup">
    <div class="popup-close">
        <button type="button" onclick="pf_layerClose();">
            <i class="xi-close-thin"></i>
        </button>
    </div>
    <textarea id="codeContents" rows="5" onkeydown="useTab(this);"></textarea>
</div>
<button type="button" id="addCodeData" class="btn btnSmall_01 btn-default">코드 추가</button>
<select id="codeCategory" class="txtDefault txtWlong_1" data-title="코드 유형 구분">
    <option selected="selected" value="HTML">HTML</option>
    <option value="css">CSS</option>
    <option value="sass">Sass</option>
    <option value="javascript">JavaScript</option>
    <option value="java">Java</option>
    <option value="python">Python</option>
    <option value="groovy">Groovy</option>
    <option value="scala">Scala</option>
    <option value="php">PHP</option>
    <option value="bash">Bash</option>
    <option value="coffeescript">CoffeesSript</option>
    <option value="go">Go</option>
    <option value="haskell">Haskell</option>
    <option value="go">Go</option>
    <option value="c">C</option>
    <option value="cpp">C++</option>
    <option value="sql">SQL</option>
    <option value="ruby">Ruby</option>
    <option value="aspnet">ASP.NET</option>
    <option value="csharp">C#</option>
    <option value="swift">Swift</option>
    <option value="objectivec">Objective-C</option>
    <option value="nohighlight">스타일 없음</option>
</select>	