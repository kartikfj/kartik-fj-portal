<%-- 
    Document   : MARKETING LEAD
    Created on : January 10, 2019, 10:06:00 AM
    Author     : Nufail Achath
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<% 
        response.setHeader("Cache-Control","no-cache"); //Forces caches to obtain a new copy of the page from the origin server
        response.setHeader("Cache-Control","no-store"); //Directs caches not to store the page under any circumstance
        response.setDateHeader("Expires", 0); //Causes the proxy cache to see the page as "stale"
        response.setHeader("Pragma","no-cache"); //HTTP 1.0 backward compatibility
%>
<jsp:useBean id="fjtuser" class="beans.fjtcouser" scope="session"/>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import = "java.util.Set"%>;
<%@page import = "java.util.Arrays"%>;
<%@page import = "java.util.HashSet"%>;
<%@page import = "java.util.List"%>;
<%@page import="com.google.gson.Gson"%>	 
<%
  DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
  Calendar cal = Calendar.getInstance();
  int week = cal.get(Calendar.WEEK_OF_YEAR);
  int iYear = cal.get(Calendar.YEAR);  
  String currCalDtTime = dateFormat.format(cal.getTime());
  request.setAttribute("CURR_YR",iYear);
  request.setAttribute("currCal", currCalDtTime);
  request.setAttribute("currWeek", week);
  String[] selected_employee_list= (String[])request.getAttribute("selected_employee_list");
  
   Set<String> set = new HashSet<>();
  if(selected_employee_list != null && selected_employee_list.length > 0){	
	  set = new HashSet<>(Arrays.asList(selected_employee_list));
	  System.out.println("iff == "+set);
  }
 
  
 %>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Faisal Jassim Trading Co L L C</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="././resources/abc/style.css" rel="stylesheet" type="text/css" />
	<link href="././resources/abc/responsive.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="././resources/abc/bootstrap.min.css">
	<script src="././resources/abc/jquery.min.js"></script>
	<script src="././resources/abc/bootstrap.min.js"></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"/>
	<script src="././resources/js/mainview.js"></script>
	<link href="././resources/css/multiple_product_list.css" rel="stylesheet" type="text/css" />
	<script src="././resources/js/multiple_product_list.js"></script>
    <link rel="stylesheet" href="././resources/bower_components/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="././resources/dist/css/skins/_all-skins.min.css">
	<link rel="stylesheet" type="text/css" href="././resources/datatables/datatables-fjtco/css/jquery.dataTables.min.css" />
	<link rel="stylesheet" type="text/css" href="././resources/datatables/buttons-fjtco/css/buttons.dataTables.min.css" />
	<script type="text/javascript" src="././resources/datatables/datatables-fjtco/js/jquery.dataTables.min.js"></script>
	<script type="text/javascript" src="././resources/datatables/datatables-fjtco/js/dataTables.buttons.min.js"></script>
	<script type="text/javascript" src="././resources/datatables/buttons-fjtco/js/buttons.flash.min.js"></script>
	<script type="text/javascript" src="././resources/datatables/ajax/excelmake/jszip.min.js"></script>
	<script type="text/javascript" src="././resources/datatables/buttons-fjtco/js/buttons.html5.min.js"></script>
	<script type="text/javascript" src="././resources/datatables/buttons-fjtco/js/buttons.print.min.js"></script>
	
	<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.5/xlsx.full.min.js"></script>
	
 
  <!-- Theme style -->
  <link rel="stylesheet" href="././resources/dist/css/AdminLTE.min.css">
  <link rel="stylesheet" href="././resources/dist/css/skins/_all-skins.min.css">
   <link rel="stylesheet" href="././resources/css/mkt-layout.css?v=13032020">
 <style>
.navbar-brand {
  padding: 0px;
}
/* new style by nufail */
.navbar-brand>img {
  height: 101%;
  width: auto;
  margin-left: 5px;
  margin-right: 6px;
}
.navbar {
    border-radius: 0px; 
}
.navbar ul li{
	
	
	font-style: normal;
    font-variant-ligatures: normal;
    font-variant-caps: normal;
    font-variant-numeric: normal;
    font-variant-east-asian: normal;
    font-stretch: normal;
    line-height: normal;
    font-size: 14px;
    font-weight: 700;
}

.navbar-default .navbar-nav>li>a:hover, .navbar-default .navbar-nav>.open>li>a, .navbar-default .navbar-nav>.open>li>a:focus, .navbar-default .navbar-nav>.open>li>a:hover{
background:#fff;
color:#008ac1;


}
#fj-page-head{padding:4px 8px !important;color:#065685;margin-top:-20px;}
#fj-page-head-box{border: none;};
 .btn-group.open .dropdown-toggle {max-width: 180px !important;overflow: hidden  !important;}
  #nmlstforrprt .open>.dropdown-menu {display: block; max-height: 314px !important;overflow-y: scroll;}
</style>

</head>
<body class="hold-transition skin-blue sidebar-mini">
 <c:if test="${empty fjtuser.emp_code}"> <jsp:forward page="index.jsp"/> </c:if>
 <c:choose>
 <c:when test="${!empty fjtuser.emp_code and ( fjtuser.role eq 'mkt' or fjtuser.role eq 'mg' or fjtuser.sales_code ne null ) and fjtuser.checkValidSession eq 1  }">
 <sql:query var="service" dataSource="jdbc/orclfjtcolocal">
		SELECT USER_TYPE, DIVN_CODE FROM FJPORTAL.MARKETING_SALES_USERS WHERE  EMPID = ?  AND ROWNUM = 1
	<sql:param value="${fjtuser.emp_code}"/>
</sql:query>
<div class="wrapper">

  <header class="main-header">
    <!-- Logo -->
    <a href="index2.html" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>FJ</b>M</span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg">
          <img src="././resources/images/logo_t5.jpg" height="49px" class="img-circle pull-left"  alt="Logo"><b>Marketing</b>
      </span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>

      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
 
          <!-- User Account: style can be found in dropdown.less -->
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-user-circle"></i>
              <span class="hidden-xs">${fjtuser.uname}</span>
            </a>
          
          </li>
           <%--Settings--%>
          <li class="dropdown notifications-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-gears"></i>
            </a>
            <ul class="dropdown-menu">
              <li class="header"><a  href="logout.jsp"> <i class="fa fa-power-off"></i> Log-Out</a></li>      
            </ul>
          </li>
          
        </ul>
      </div>
    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
      <!-- Sidebar user panel -->
      <!-- search form -->
       <form method="POST" action="ConsultantLeads" class="sidebar-form">
        <div class="input-group">
          <input type="text" class="form-control" placeholder="Search by consultant..." name="srch-term" id="srch-term" type="text" required>
          <input type="hidden" name="octjf" value="sbcnfpdw"/>
          <span class="input-group-btn">
                <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
                </button>
              </span>
        </div>
      </form>
      <!-- /.search form -->
      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu" data-widget="tree">
        <c:if test="${fjtuser.emp_code eq 'E004272' || fjtuser.emp_code eq 'E003066'}">
	         <li><a href="MktDashboard"><i class="fa fa-dashboard"></i><span>Dashboard - Sales Leads</span></a></li>
	         <li ><a href="SalesLeads"><i class="fa fa-pie-chart"></i><span>Sales Leads Details</span></a></li>
         </c:if>
          <c:if test="${!empty service.rows}">  
         	<li><a href="SupportRequest"><i class="fa fa-table"></i><span> BDM Support Request </span></a></li>
         </c:if>
          <li><a href="ConsultantLeads"><i class="fa fa-line-chart"></i><span>Consultant Approval Status</span></a></li>
         <li><a href="ProjectLeads"><i class="fa fa-columns"></i><span>Project Stages 0 & 1</span></a></li>  
         <li class="active"><a href="ConsultantProductReport"><i class="fa fa-columns"></i><span>Consultant Product Report</span></a></li>               
         <li><a href="homepage.jsp"><i class="fa fa-home"></i><span>HR Portal</span></a></li>      
      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        Consultant Product Status
        <small>Marketing Portal</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="homepage.jsp"><i class="fa fa-calendar"></i> Home</a></li>
        <li class="active">Marketing</li>
      </ol>
    </section>

    <!-- Main content -->
    <section class="content">
    
           
<div  class="fjtco-table" ><br/>
<form  class="form-inline" method="post" action="ConsultantProductReport"> 

             <i class="fa fa-filter" style="font-size: 24px;color: #065685;"></i>
                 <input type="hidden" id="fjtco" name="fjtco" value="rpeotrpad" />
                  <input type="hidden" id="uid" name="uid" value="E001090" />
         
 <div class="form-group" id="nmlstforrprt"> 

<select class="form-control"  id="regularisation_list" multiple="multiple" name="consltList" required>
   <c:forEach var="consultLst"  items="${CLFCL}" >
		<c:choose>
	 		<c:when test="${fn:contains(setValves,consultLst.conslt_name)}">	 					
	 			  <option value="${consultLst.conslt_name}" selected >${consultLst.conslt_name}</option>
	 		</c:when>
	 		<c:otherwise>
	 			 <option value="${consultLst.conslt_name}" >${consultLst.conslt_name}</option>
	 		</c:otherwise>
	 </c:choose>
</c:forEach>
</select>
</div>

<div class="form-group" id="nmlstforrprt">  
  
<select class="form-control form-control-sm"  id="leave_type_list" multiple="multiple" name="productList" required>
   					
	  <c:forEach var="productLst"  items="${PLFCL}" >
      		<option value="${productLst.product}">${productLst.product}</option>
      </c:forEach>
</select>

</div>
<div class="form-group">
<button type="submit" class="btn btn-primary"  onclick="getSeletedval();">Details</button></div>
</form>

 <button class="btn btn-xs btn-danger" id="exportPo" onClick="exportToExcel();"><i class="fa fa-file-excel-o"></i> Export</button>    
<%-- <input id="pressme" type="button" onClick="exportToExcel(${CS_LV_LIST}, 'exported_data.xlsx')" value="Press"> --%>
</div>
	<c:if test="${!empty CS_LV_LIST}">
<div class="tb">

<table class='table table-bordered small' id="leveRprt-table">
<!-- <thead><tr> -->


<!-- <th>Consultant</th><th>Product</th> -->
<!-- </tr></thead> -->
<tbody>
	<c:forEach var="rowData" items="${CS_LV_LIST}">
       <tr>
            <c:forEach var="cellData" varStatus="loop" items="${rowData}" >
              
                <td><c:out value="${cellData}"></c:out></td>                    
               
            </c:forEach>
        </tr>
    </c:forEach>

<%--        <c:forEach var="REG_REP"  items="${CS_LV_LIST}" > --%>
					   
<!-- 			<tr>             -->
<%-- 			<td>${REG_REP.conslt_name}</td> --%>
<%-- 			<td>${REG_REP.product}</td> --%>
<%-- 			<td>${REG_REP.status}</td> --%>
<%-- 			<td>${REG_REP.division}</td> --%>
<%-- 			<td>${REG_REP.remarks}</td>			 --%>
<!-- 			</tr>		    -->
<%-- 	   </c:forEach> --%>
	</tbody>  </table> <br/>
	  </div>
	  </c:if>


 <!--Box End -->
	
    
    </section>
    <!-- /.content -->

   </div>
  <!-- /.content-wrapper -->
  <footer class="main-footer">
    <div class="pull-right hidden-xs">
      <b>Version</b> 1.0.0
    </div>
    <strong>Copyright &copy; 1988-${CURR_YR} <a href="http://www.faisaljassim.ae">FJ-Group</a>.</strong> All rights
    reserved.
  </footer>
	
  
</div>
<script src="././resources/bower_components/fastclick/lib/fastclick.js"></script>
<script src="././resources/dist/js/adminlte.min.js"></script>
<!-- page script start -->
<script>
var poList = <%=new Gson().toJson(request.getAttribute("CS_LV_LIST"))%>;  

$(function () {
    $('#leave_type_list').multiselect({
    	nonSelectedText: 'Select Product',
        includeSelectAllOption: true
    });
});


$(function () {
	
    $('#regularisation_list').multiselect({
    	nonSelectedText: 'Select Consultant',
        includeSelectAllOption: true
    });
});

 function selectAll(box) {
        for(var i=0; i<box.length; i++) {
            box.options[i].selected = true;
        }
    }
 function getSeletedval(){
		
	    var selectedValues = [];    
	    $("#leave_type_list :selected").each(function(){
	        selectedValues.push($(this).val()); 
	    });
	    return true;
	    //alert(selectedValues);
	   
	
}
function preLoader(){ $('#laoding').show();}


function exportToExcel() {
	

var twoDArray = <%=new Gson().toJson(request.getAttribute("CS_LV_LIST"))%>; 

    var wb = XLSX.utils.book_new();
  
    var ws = XLSX.utils.aoa_to_sheet(twoDArray);
    XLSX.utils.book_append_sheet(wb, ws, 'Sheet1');
    
    var wbout = XLSX.write(wb, { bookType: 'xlsx', type: 'binary' });

    // Convert the binary string to a Blob
    var blob = new Blob([s2ab(wbout)], { type: 'application/octet-stream' });

    // Create a link element to trigger the download
    var link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.download = "abc.xlsx";

    // Append the link to the document and trigger the download
    document.body.appendChild(link);
    
    link.click();

    // Remove the link from the document
    document.body.removeChild(link);
  }

function s2ab(s) {
    var buf = new ArrayBuffer(s.length);
    var view = new Uint8Array(buf);
    for (var i = 0; i !== s.length; ++i) {
      view[i] = s.charCodeAt(i) & 0xFF;
    }
    return buf;
  }

</script>
<!-- page Script  end -->

</c:when>
<c:otherwise>

        <body onload="window.top.location.href='../logout.jsp'">
   
            
        </body>
  
</c:otherwise>
</c:choose>
</html>