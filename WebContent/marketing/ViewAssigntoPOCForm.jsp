<%-- 
    Document   : EDIT LEAD(Form1) and Sales Engineer Support Request (Form2)
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
<%
  DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
  Calendar cal = Calendar.getInstance();
  int week = cal.get(Calendar.WEEK_OF_YEAR);
  int iYear = cal.get(Calendar.YEAR);  
  String currCalDtTime = dateFormat.format(cal.getTime());
  request.setAttribute("CURR_YR",iYear);
  request.setAttribute("currCal", currCalDtTime);
  request.setAttribute("currWeek", week);
  
 %>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>Faisal Jassim Trading Co L L C</title>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="././resources/abc/style.css" rel="stylesheet" type="text/css" />
	<link href="././resources/abc/responsive.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="././resources/abc/bootstrap.min.css">
	<script src="././resources/abc/jquery.min.js"></script>
	<script src="././resources/abc/bootstrap.min.js"></script>
	<script src="././resources/js/mainview.js"></script>	
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
	<link rel="stylesheet" href="././resources/bower_components/datepicker/dist/css/bootstrap-datepicker.min.css">
   <%--Theme style  --%>
    <link rel="stylesheet" href="././resources/bower_components/select2/dist/css/select2.min.css">
    <link rel="stylesheet" href="././resources/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="././resources/dist/css/skins/_all-skins.min.css">
    <link rel="stylesheet" href="././resources/css/mkt-layout.css?v=13032020">

</head>
<script type="text/javascript">
$(document).ready(function() {
	 $('#laoding').hide();});
</script>
<body class="hold-transition skin-blue sidebar-mini">
 <c:if test="${empty fjtuser.emp_code}"> <jsp:forward page="index.jsp"/> </c:if>
 <c:choose>
 <c:when test="${!empty fjtuser.emp_code and ( fjtuser.role eq 'mkt' or fjtuser.role eq 'mg' or fjtuser.sales_code ne null )   and fjtuser.checkValidSession eq 1  }">
 <sql:query var="service" dataSource="jdbc/orclfjtcolocal">
	SELECT USER_TYPE, DIVN_CODE FROM FJPORTAL.MARKETING_SALES_USERS WHERE  EMPID = ?  AND ROWNUM = 1
	<sql:param value="${fjtuser.emp_code}"/>
</sql:query>
<div class="wrapper">

  <header class="main-header">
     <%--Logo  --%>
    <a href="././homepage.jsp" class="logo">
       <%--mini logo for sidebar mini 50x50 pixels  --%>
      <span class="logo-mini"><b>FJ</b>M</span>
       <%--logo for regular state and mobile devices  --%>
      <span class="logo-lg">
          <img src="././resources/images/logo_t5.jpg" height="49px" class="img-circle pull-left"  alt="Logo"><b>Marketing</b>
      </span>
    </a>
     <%--Header Navbar: style can be found in header.less  --%>
    <nav class="navbar navbar-static-top">
       <%--Sidebar toggle button --%>
      <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
        <span class="sr-only">Toggle navigation</span>
      </a>

      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
           <%--User Account: style can be found in dropdown.less  --%>
          <li class="dropdown user user-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-user-circle"></i>
              <span class="hidden-xs"><c:out value="${fjtuser.uname}"/></span>
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
   <%--Left side column. contains the logo and sidebar  --%>
  <aside class="main-sidebar">
     <%--sidebar: style can be found in sidebar.less  --%>
    <section class="sidebar">
       <%--Sidebar user panel  --%>
       <%--search form  --%>
      <form action="#" method="get" class="sidebar-form">
        <div class="input-group">
          <input type="text" name="q" class="form-control" placeholder="Search...">
          <span class="input-group-btn">
                <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
                </button>
              </span>
        </div>
      </form>
       <%--/.search form  --%>
       <%--sidebar menu: : style can be found in sidebar.less  --%>
      <ul class="sidebar-menu" data-widget="tree">
         <c:if test="${fjtuser.emp_code eq 'E004272' || fjtuser.emp_code eq 'E003066'}">
	         <li><a href="MktDashboard"><i class="fa fa-dashboard"></i><span>Dashboard - Sales Leads</span></a></li>
	         <li ><a href="SalesLeads"><i class="fa fa-pie-chart"></i><span>Sales Leads Details</span></a></li>
         </c:if>
          <li><a href="AssignToPOC"><i class="fa fa-table"></i><span> Assign task to POC </span></a></li>
          <c:if test="${!empty service.rows}">  
         	<li><a href="SupportRequest"><i class="fa fa-table"></i><span> BDM Support Request </span></a></li>
         </c:if>
         <li><a href="ConsultantLeads"><i class="fa fa-line-chart"></i><span>Consultant Approval Status</span></a></li>
         <li><a href="ProjectLeads"  class="active"><i class="fa fa-columns"></i><span>Major Projects</span></a></li>                 
         <li><a href="././homepage.jsp"><i class="fa fa-home"></i><span>HR Portal</span></a></li>     
      </ul>
    </section>
     <%--/.sidebar  --%>
  </aside>

   <%--Content Wrapper. Contains page content  --%>
  <div class="content-wrapper">
     <%--Content Header (Page header)  --%>
    <section class="content-header">
      <h1> BDM Support Request View  <small>Marketing Portal</small> </h1>
      <ol class="breadcrumb">
        <li><a href="homepage.jsp"><i class="fa fa-calendar"></i> Home</a></li>
        <li class="active">Marketing</li>
      </ol>
    </section>
     <%--Main content  --%>
    <section class="content">
    <div class="row">
    <div class="col-md-12">
	   <%--SELECT2 EXAMPLE  --%>
      <div class="box box-default">
        <div class="box-header with-border">
          <h3 class="box-title">Sales Lead Data Form</h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
          </div>
        </div>
         <%--/.box-header  --%>
        <div class="box-body">
         <%-- Process - 1 </span> --%>
         <div class="custom-table">
         <table  id="sr-view-table">
        <c:forEach var="requestList"  items="${SRLIST}" >
                 
                <tr>
                
                  <th>Code</th>
                  <td style=" border-top: 1px solid #bbb;">FJMPOC ${requestList.id}</td>
                </tr>
                <tr>   
                  <th>SE Name</th>
                  <td>${requestList.seName}</td>
                </tr>
                
               <tr>    
                  <th>Task</th>
                  <td>${requestList.bdmTaskName}</td>
                </tr>
                <tr>     
                  <th>Initial Remarks</th>
                  <td>${requestList.initialReamrks}</td>
                </tr>
                <tr>    
                  <th>BDM requested On</th>
                  <td><fmt:parseDate value="${requestList.requestedOn}" var="theDate3"    pattern="yyyy-MM-dd" />
		                  <fmt:formatDate value="${theDate3}" />
		           </td>
                  
                </tr>
                <tr>
                
                <th>Ack. Status by POC</th>
                <td>
                    <c:choose>
		        <c:when test="${requestList.p2Status eq 0}">
		        <b style="color:blue;">Pending</b>
		        </c:when>
		        <c:when test="${requestList.p2Status eq 1}">
		           <b style="color:green;">Accepted / Initiated</b>
		         </c:when>
		           <c:when test="${requestList.p2Status eq 3}">
		            <b style="color:red;">Others</b>
		         </c:when>
		        <c:otherwise>
		        <b style="color:red;">Declined</b>
		        </c:otherwise>
		        
		        </c:choose>
                </td>
                </tr>                
                <tr>    
                  <th>Ack. Remarks by POC</th>
                  <td>${requestList.se_accept_remarks}</td>	
               </tr>
                 <tr>    
                  <th>POC Follow-Up Status</th>
                  <td>
                       <c:choose>
		        <c:when test="${requestList.p3Status eq 1}">
		           <b style="color:green;">Completed</b>
		         </c:when>
		          <c:when test="${requestList.p2Status gt  1}">
		           <b>N/A</b>
		         </c:when>
		           <c:when test="${requestList.p2Status eq 1 and requestList.p3Status eq 0}">
		         <b style="color:blue;">Pending</b>
		         </c:when>
		        <c:otherwise>
		        <b>-</b>
		        </c:otherwise>		        
		        </c:choose> 
                  </td>	
               </tr>
               <tr>     
                  <th>POC Follow-Up Remarks</th>                 
<%--                   	<c:if test="${requestList.mkt_remarks ne null}"> --%>
<%--                   		<td>${requestList.bdm_remarks}</td> --%>
<%-- 					</c:if>					 --%>
					<td><c:forEach items="${requestList.followupRemarks}" var = "follupremarks" varStatus="status">
	                	<dd>${status.index + 1}.<c:out value="${follupremarks}" /></dd>
	                </c:forEach></td>
              </tr>
               <tr>     
                  <th>POC Follow-Up On</th>
                  <td>
                       <fmt:parseDate value="${requestList.se_followup_on}" var="theDate2"    pattern="yyyy-MM-dd HH:mm" />
		               <fmt:formatDate value="${theDate2}" />
		          </td>
               </tr><tr>     
                  <th> BDM Final Remarks</th>
                  <td>${requestList.bdm_remarks}</td>
              </tr><tr>      
                  <th>BDM Closed On</th>
                  <td>
                          <fmt:parseDate value="${requestList.bdm_update_on}" var="theDate2"    pattern="yyyy-MM-dd HH:mm" />
		                  <fmt:formatDate value="${theDate2}" />
		         </td>
                </tr>
                </c:forEach>
           </table>
           </div>
          <c:if test="${!empty MSG}">
           <div class="row mkt-form-row-border" id="marketing-process-1">
              <div class="alert alert-secondary" role="alert">
				  ${MSG}
				</div>
          </div>
          </c:if> 
         <%--/.box-body  --%>
      </div>
       <%--/.box  --%>
      </div>
      </div>
	 </div>
	
    
      
    </section>
     <%--/.content  --%>
      <div id="laoding" class="loader" ><img src="././resources/images/wait.gif"></div>
   </div>
   <%--/.content-wrapper  --%>
  <footer class="main-footer">
    <div class="pull-right hidden-xs">
      <b>Version</b> 1.0.0
    </div>
    <strong>Copyright &copy; 1988-${CURR_YR} <a href="http://www.faisaljassim.ae">FJ-Group</a>.</strong> All rights
    reserved.
  </footer>

</div>

<script src="././resources/bower_components/datepicker/dist/js/bootstrap-datepicker.min.js"></script>
<script src="././resources/bower_components/select2/dist/js/select2.full.min.js"></script>
<script src="././resources/bower_components/fastclick/lib/fastclick.js"></script>
<script src="././resources/dist/js/adminlte.min.js"></script>
 <%--page script start  --%>

 <%--page Script  end  --%>

</c:when>
<c:otherwise>

        <body onload="window.top.location.href='logout.jsp'">
   
            
        </body>
  
</c:otherwise>
</c:choose>
</body>
</html>