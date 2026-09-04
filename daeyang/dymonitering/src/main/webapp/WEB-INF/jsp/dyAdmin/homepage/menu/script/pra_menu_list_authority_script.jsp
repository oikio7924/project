<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/taglib/taglib.jspf"%>


<script>

$(function(){
	$('.authList .tree > ul').attr('role', 'tree').find('ul').attr('role', 'group');
	$('.authList .tree').find('.parent_li').attr('role', 'treeitem').find(' > span').attr('title', 'Collapse this branch').on('click', function(e) {
		var children = $(this).parent('li.parent_li').find(' > ul > li');
		if (children.is(':visible')) {
			children.hide('fast');
			$(this).attr('title', 'Expand this branch').find(' > i').removeClass().addClass('fa fa-lg fa-plus-circle');
		} else {
			children.show('fast');
			$(this).attr('title', 'Collapse this branch').find(' > i').removeClass().addClass('fa fa-lg fa-minus-circle');
		}
		e.stopPropagation();
	});	
	
	$('input[name=accessRole]').on('click',function(){
		
		//뷰권한 숨김
		pf_viewAuthCheck($(this));
		$(this).parents('li.parent_li').children('.settings').find('.viewLebel').hide();
		
		//하위 checkbox들 checked 처리
		$(this).closest('li').find('input[name=accessRole]').prop('checked',$(this).is(':checked')).each(function(){
			
			pf_viewAuthCheck($(this));	//뷰권한 체크
			
			if($(this).hasClass('board')){
				pf_changeBoardAuth($(this))	
			}
		});
		
		$(this).closest('li').find('input[name=viewRole]:not(:checked)').prop('checked',$(this).is(':checked')).each(function(){
			/* if($(this).hasClass('board')){
				pf_changeBoardAuth($(this))	
			} */
		});
		
		//부모 checkbox checked 처리
		if($(this).is(':checked')){
			$(this).parents('li.parent_li').children('.settings').find('input[name=accessRole]').prop('checked',true);
			$(this).parents('li.parent_li').children('.settings').find('input[name=viewRole]').prop('checked',true);
			var parentLi = $(this).parents('li.parent_li').children('.settings').find('input[name=accessRole]');
			if(parentLi.is(':checked')){
				if(parentLi.hasClass('board')){
					pf_changeBoardAuth(parentLi)	
				}
			}
		}
		
	})
	
// 	$('input[name=accessRole].board').each(function(){
// 		pf_changeBoardAuth($(this))
// 	})
	
	$('input[name=viewRole]').on('click',function(){
		
		//하위 checkbox들 checked 처리
		$(this).closest('li').find('input[name=viewRole]').prop('checked',$(this).is(':checked'));
		
		//부모 checkbox checked 처리
		if($(this).is(':checked')){
			$(this).parents('li.parent_li').children('.settings').find('input[name=viewRole]').prop('checked',true);
		}
		
	});
	
	$('.settings input[type=checkbox].all').on('click',function(){
		$(this).closest('.settings').find('input[type=checkbox]:not(.access)').prop('checked',$(this).is(':checked'));
	})
	
	$('.settings input[type=checkbox]:not(.all)').on('click',function(){
		pf_boardAuthAllCheck($(this).closest('.settings'));
		
	})
	
	$('.settings').each(function(){
		pf_boardAuthAllCheck(this);
	})
		
	if('${action}' == 'Insert'){
		$('input[name=accessRole]').prop('checked',true);
	}
	
	//접근권한 체크된 뷰권한 숨김
	$('input[type=checkbox][name=viewRole].checked').each(function(){
		$(this).closest('label').hide();
	});
	
});

function pf_viewAuthCheck(obj){
	
	if($(obj).is(':checked')){
		
		$(obj).closest('div').find('input[name=viewRole]').prop('checked',false);
		$(obj).closest('div').find('.viewLebel').hide();
		
	}else{
		$(obj).closest('div').find('.viewLebel').show();
	}
}


/**
 * 게시판 모드 권한 체크박스 체크 여부 
 * obj  = .setting 객체
 */
function pf_boardAuthAllCheck(obj){
	var unCheckedLength = $(obj).find('input[type=checkbox]:not(.all):not(:checked)').length;
	$(obj).find('input[type=checkbox].all').prop('checked',unCheckedLength == 0)
}



function pf_allOpenAndClose(obj){
	$ul = $('.menu-tree').find('ul.parent_ul');

	if($(obj).find('i').hasClass('fa-plus')){
		$(obj).find('i').addClass('fa-minus').removeClass('fa-plus');
		$(obj).find('font').text('모두 닫기');
		$ul.find('li.parent_li').each(function(){
			$(this).find('ul > li').show('fast');
			$(this).attr('title', 'Collapse this branch').find(' > i').removeClass().addClass('fa fa-lg fa-minus-circle');
		})
	}else{
		$(obj).find('i').addClass('fa-plus').removeClass('fa-minus');
		$(obj).find('font').text('모두 펼치기');
		$ul.find('li.parent_li').each(function(){
			$(this).find('ul > li').hide('fast');
			$(this).attr('title', 'Expand this branch').find(' > i').removeClass().addClass('fa fa-lg fa-plus-circle');
		})
	}
	
	
}

function pf_changeBoardAuth(obj){
	var mnKey = $(obj).val();
	if(mnKey){
		var checkbox = $('.settings .checkbox.'+mnKey);
		checkbox.find('.boardRole').hide();
		if($(obj).is(':checked')){
			checkbox.find('label.boardRole').show();
		}else{
			checkbox.find('.boardRole input[type=checkbox]').prop('checked',false);
			checkbox.find('span.boardRole').show();
		}
	}else{
		var mnKey2 = $(obj).data('val');
		var checkbox2 = $('.settings .checkbox.'+mnKey2);
		checkbox2.find('.boardRole').hide();
		checkbox2.find('.boardRole input[type=checkbox]').prop('checked',false);
		checkbox2.find('span.boardRole').show();
	}
}

function pf_selectAll(check){
	$('.settings input[type=checkbox]').prop('checked',check);
	
	$('input[name=accessRole].board').each(function(){
		pf_changeBoardAuth($(this))
	})
}

</script>