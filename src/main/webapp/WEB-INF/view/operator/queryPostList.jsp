<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>queryPostList</title>
<%@include file="../includes/commonHead.jsp" %>

<script type="text/javascript" >
var treeGrid = null;
var orgTree = null;
$(document).ready(function() {
	orgTree = $('#organizationTree').tree({
		url : '${contextPath}/organization/queryOrganizationPostTreeNodeListByAuth.action',
		idFiled : 'id',
		parentField : 'parentId',
		textFiled : 'name',
		iconFiled : function(item){
			if(item && item.type == 1){
				return 'group_group';
			}else{
				return 'folder_user';	
			}
		},
		fit : true,
		fitColumns : true,
		border : false,
		onClick : function(node){
			if(node['attributes'].type  == 0){
				$('#treeGrid').treegrid('load',{
					organizationId: node.id
				});
			}else{
				$('#treeGrid').treegrid('load',{
					parentPostId: node.id
				});
			}
		}
	});
	
	treeGrid = $('#treeGrid').treegrid({
		url : '${contextPath}/post/queryPostList.action',
		idField : 'id',
		parentField : 'parentId',
		treeField : 'name',
		iconFiled : function(item){
			return 'group_group';	
		},
		fit : true,
		fitColumns : true,
		border : false,
		frozenColumns : [ [ {
			title : '职位id',
			field : 'id',
			width : 150,
			hidden : true
		},{
			field : 'parentId',
			title : '上级职位ID',
			width : 150,
			hidden : true
		},{
			field : 'name',
			title : '职位名称',
			width : 200
		}, {
			field : 'code',
			title : '职位编号',
			width : 230
		}] ],
		columns : [ [ {
			field : 'fullName',
			title : '组织全称',
			width : 150
		},{
			field : 'action',
			title : '操作',
			width : 50,
			formatter : function(value, row, index) {
				var str = '';
				if ($.canEdit) {
					str += $.formatString('<img onclick="editFun(\'{0}\');" src="{1}" title="编辑"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/pencil.png');
				}
				str += '&nbsp;';
				if ($.canDelete) {
					str += $.formatString('<img onclick="deleteFun(\'{0}\');" src="{1}" title="删除"/>', row.id, '${pageContext.request.contextPath}/style/images/extjs_icons/cancel.png');
				}
				return str;
			}
		}, {
			field : 'remark',
			title : '备注',
			width : 200
		} ] ],
		toolbar : '#toolbar',
		onContextMenu : function(e, row) {
			e.preventDefault();
			$(this).treegrid('unselectAll');
			$(this).treegrid('select', row.id);
			$('#menu').menu('show', {
				left : e.pageX,
				top : e.pageY
			});
		},
		onLoadSuccess : function() {
			parent.$.messager.progress('close');
			$(this).treegrid('tooltip');
		}
	});
});
function refreshTree(){
	$('#organizationTree').tree('reload');
	$('#treeGrid').treegrid('reload');
}
/*
 * 打开添加组织界面
 */
function addFun() {
	DialogUtils.progress({
        text : '加载中，请等待....'
	});
	DialogUtils.openModalDialog(
		"addOrganization",
		"添加组织",
		"${contextPath}/post/toAddPost.action",
		550,165,function(){
		$('#treeGrid').treegrid('reload');
	});
}
function redo() {
	var node = treeGrid.treegrid('getSelected');
	if (node) {
		treeGrid.treegrid('expandAll', node.id);
	} else {
		treeGrid.treegrid('expandAll');
	}
}

function undo() {
	var node = treeGrid.treegrid('getSelected');
	if (node) {
		treeGrid.treegrid('collapseAll', node.id);
	} else {
		treeGrid.treegrid('collapseAll');
	}
}
</script>
</head>
<body class="easyui-layout">
		<div data-options="region:'west',title:'组织结构',split:true,
			tools : [{ iconCls : 'database_refresh',handler : function() {refreshTree();} }]" 
			style="width:230px;">
			<ul id="organizationTree"></ul>
		</div> 
		<div data-options="region:'center'" style="padding:5px;background:#eee;">
			<div class="easyui-layout" data-options="fit:true,border:false">
				<div data-options="region:'center',border:false" title="" style="overflow: hidden;">
					<table id="treeGrid" style="width:fit;height:fit"></table>
				</div>
			</div>
			
			<div id="toolbar" style="display: none;">
				<c:if test="${true}">
					<a onclick="addFun();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'pencil_add'">添加</a>
				</c:if>
				<a onclick="redo();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'resultset_next'">展开</a> 
				<a onclick="undo();" href="javascript:void(0);" class="easyui-linkbutton" data-options="plain:true,iconCls:'resultset_previous'">折叠</a> 
				<a onclick="treeGrid.treegrid('reload');" href="javascript:void(0);" 
					class="easyui-linkbutton" data-options="plain:true,iconCls:'transmit'">刷新</a>
			</div>
		
			<div id="menu" class="easyui-menu" style="width: 120px; display: none;">
				<c:if test="${true}">
					<div onclick="addFun();" data-options="iconCls:'pencil_add'">增加</div>
				</c:if>
				<c:if test="${true}">
					<div onclick="deleteFun();" data-options="iconCls:'pencil_delete'">删除</div>
				</c:if>
				<c:if test="${true}">
					<div onclick="editFun();" data-options="iconCls:'pencil'">编辑</div>
				</c:if>
			</div>
		
		</div> 
</body>