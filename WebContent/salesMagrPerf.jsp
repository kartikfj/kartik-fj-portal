<%-- 
    Document   : SIP SALES PERFORM DASHBAORD FOR DM  
--%>
<%@include file="sipHead.jsp" %>
 <c:set var="syrtemp" value="${selected_Year}" scope="page" />
<!DOCTYPE html>
<html>

<head>  

<script>
document.addEventListener('DOMContentLoaded', function() {
    var scodeSelect = document.getElementById('scode');
    
    // Check if a value is set and not "0" on page load
    if (scodeSelect && scodeSelect.value && scodeSelect.value !== "0") {
        sm_performance_booking(); // Call the function with the default value
    }
});

</script>


<style>
table.dataTable thead th,table.dataTable thead td {
    padding: 5px 5px;
    border-bottom: 1px solid #111
}
.modal-subtitle2,.modal-subtitle3 {  
    font-weight: bold !important;
}
@media print {
  /* Ensure right alignment for table cells when printing */
  table tr td:not(:first-child) {
    text-align: right !important;
  }
  table tr:last-child td {
    font-weight: bold !important;
}
 @page { height: 842px;   width: 595px;  margin-left: auto;   margin-right: auto; margin-bottom:-50px;} 
}
</style>
<style>



.align-right {
    display: inline-block;
    text-align: right;
    width: 100px; /* Adjust width as needed */
}

.stage-details-graph {z-index: 50; background: rgba(255, 255, 255, 0.7); border: 2px solid #3c8dbc;font-size: 15px; color: #3c8dbc; position: absolute; padding: 2px 0px 2px 6px;cursor: pointer; top: 5px; right: 150px; border-radius: 5px;}

.info-section {
    margin-bottom: 2px;
    display: flex;
    flex-direction: column;
    align-items: flex-start; /* Align items to the left */
    gap: 2px;
}

.info-section h6 {
    margin: 1px 0;
}

.gauge-container {
    display: flex;
    justify-content: flex-start; /* Align items to the left */
    align-items: center;
    margin-top: 1px;
    padding: 10px;

}

.gauge-box {
    background-color: #f9f9f9;
    border: 1px solid #ddd;
    border-radius: 1px;
    padding: 0px;
    width: 60px; /* Adjusted width for smaller size */
    height: 70px; /* Adjusted height for smaller size */
    display: flex;
    justify-content: center;
    align-items: center;
}

.gauge-booking {
    background-color: #ff9999;
}

.gauge-billing {
    background-color: #99ff99;
}
</style>



<link rel="stylesheet" href="https://ajax.googleapis.com/ajax/libs/jqueryui/1.13.2/themes/smoothness/jquery-ui.css">
<script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.13.2/jquery-ui.min.js"></script>
 <script type="text/javascript">
 var currYear = parseInt('${CURR_YR}');
 var slctdYear = parseInt('${syrtemp}');
 var durationFltr = (slctdYear < currYear)? 'FY' : 'YTD'; 
 var Million = 1000000; 
 var selectdSalesId = "${selected_salesman_code}";
 var totLosts = 0, targeteportsList = <%=new Gson().toJson(request.getAttribute("JIHLA"))%>; 
 var salesEngsList = <%=new Gson().toJson(request.getAttribute("SEngLst"))%>; 
 $(document).ready(function() {  $('.select2').select2();  });  

 const seList   =  <%=new Gson().toJson(request.getAttribute("s_engList"))%>;
  </script> 



 <c:set var="sales_egr_code" value="0" scope="page" /> 
 <c:set var="aging30" value="0" scope="page" /> 
 <c:set var="aging3060" value="0" scope="page" /> 
 <c:set var="aging6090" value="0" scope="page" /> 
 <c:set var="aging90120" value="0" scope="page" /> 
 <c:set var="aging120180" value="0" scope="page" /> 
 <c:set var="aging181" value="0" scope="page" /> 
 
  <c:forEach var="rcvbl_list"  items="${ORAR}" > 
  <c:set var="aging30" value="${rcvbl_list.aging_1}" scope="page" /> 
  <c:set var="aging3060" value="${rcvbl_list.aging_2}" scope="page" /> 
  <c:set var="aging6090" value="${rcvbl_list.aging_3}" scope="page" /> 
  <c:set var="aging90120" value="${rcvbl_list.aging_4}" scope="page" /> 
  <c:set var="aging120180" value="${rcvbl_list.aging_5}" scope="page" /> 
  <c:set var="aging181" value="${rcvbl_list.aging_6}" scope="page" /> 
  </c:forEach> 
 
 <c:set var="year_target" value="0" scope="page" /> 
 <c:set var="actual" value="0" scope="page" /> 
 <c:set var="guage_bkng_ytd_target" value="0" scope="page" /> 
  <c:set var="guage_blng_ytd_target" value="0" scope="page" /> 
 <c:forEach var="ytm_tmp1" items="${YTM_BOOK}">  
 <c:set var="year_target" value="${ytm_tmp1.yr_total_target}" scope="page" />
 <c:set var="actual" value="${ytm_tmp1.ytm_actual}" scope="page" />
 <c:choose>
 	<c:when test="${syrtemp lt CURR_YR}">
 			<c:set var="guage_bkng_ytd_target" value="${ytm_tmp1.yr_total_target}" scope="page" />
 	</c:when>
 	<c:otherwise>		
  		<c:set var="guage_bkng_ytd_target" value="${ytm_tmp1.ytm_target}" scope="page" />
 	</c:otherwise>
 </c:choose>
 </c:forEach>

 
 <c:set var="year_targetbl" value="0" scope="page" />
 <c:set var="actualbl" value="0" scope="page" />
 <c:forEach var="ytm_tmp2" items="${YTM_BILL}">  
 <c:set var="year_targetbl" value="${ytm_tmp2.yr_total_target}" scope="page" /> <c:set var="actualbl" value="${ytm_tmp2.ytm_actual}" scope="page" />
   <c:choose>
 	<c:when test="${syrtemp lt CURR_YR}">
 		  <c:set var="guage_blng_ytd_target" value="${ytm_tmp2.yr_total_target}" scope="page" /> 
 	</c:when>
 	<c:otherwise>		
  		  <c:set var="guage_blng_ytd_target" value="${ytm_tmp2.ytm_target}" scope="page" /> 
 	</c:otherwise>
 </c:choose>
 </c:forEach>
 <script type="text/javascript"> 
 google.charts.load('current', {'packages':['corechart', 'gauge','table']});

 //google.charts.setOnLoadCallback(drawWeekylySalesSummaryS2S3S4);
 
 
    </script>


 </head>
 <c:choose>
<c:when test="${!empty fjtuser.emp_code and !empty fjtuser.sales_code  and fjtuser.checkValidSession eq 1}">
 <c:set var="sales_egr_code" value="${fjtuser.sales_code}" scope="page" /> 
 <body class="hold-transition skin-blue sidebar-mini">
 <div class="container">
<div class="wrapper">

  <header class="main-header" style="background-color: #367fa9;">
    <!-- Logo -->
    <a href="#" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>FJ</b>D</span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b>Dashboard</b></span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
      <!-- Sidebar toggle button-->
      <a href="#" class="sidebar-toggle" data-toggle="push-menu" role="button">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>
      

    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
 

      <!-- sidebar menu: : style can be found in sidebar.less -->
<!--       <ul class="sidebar-menu" data-widget="tree"> -->
<%--       		<c:if test="${fjtuser.role eq 'mg' or fjtuser.role eq 'gm'}"> --%>
<!--       		 <li><a href="SipBranchPerformance"><i class="fa fa-building-o"></i><span>Branch Performance</span></a></li> -->
<%--       		</c:if> --%>
<!--              <li><a href="DmInfo.jsp"><i class="fa fa-dashboard"></i><span>Sales Engineers Performance</span></a></li> -->
<!--              <li  class="active"><a href="SalesManagerInfo.jsp"><i class="fa fa-dashboard"></i><span>Sales Manager Performance</span></a></li> -->
<%--              <c:if test="${fjtuser.role eq 'mg' or fjtuser.role eq 'gm'}"> --%>
<!-- 	             <li><a href="DisionInfo.jsp"><i class="fa fa-line-chart"></i><span>Sub Division Performance </span></a></li> -->
<!-- 	             <li ><a href="CompanyInfo.jsp"><i class="fa fa-pie-chart"></i><span>Division Performance</span></a></li> -->
<!-- 	             <li><a href="SipUserActivity"><i class="fa fa-table"></i><span>SE Activity History</span></a></li> -->
<%--              </c:if> --%>
<!--              <li><a href="SipJihDues"><i class="fa fa-table"></i><span>JIH Dues</span></a></li>    -->
<!--              <li><a href="SipStageFollowUpController"><i class="fa fa-database"></i><span>Stage Follow-Up</span></a></li> -->
<%--              <c:if test="${fjtuser.role eq 'mg' or fjtuser.role eq 'gm'}"> --%>
<!--              	<li><a href="sipWeeklyReport"><i class="fa fa-bar-chart"></i><span>Weekly-Sales Report</span></a></li> -->
<%--              </c:if> --%>
<!--              <li><a href="homepage.jsp"><i class="fa fa-home"></i><span>HR Portal</span></a></li> -->
         
<!--       </ul> -->
		<ul class="sidebar-menu" data-widget="tree">
      		<c:choose>
             <c:when test="${fjtuser.role eq 'mg' and fjtuser.sales_code ne null}"> 
      		 	 <li><a href="SipBranchPerformance"><i class="fa fa-building-o"></i><span>Branch Performance</span></a></li> 
                 <li><a href="DmInfo.jsp"><i class="fa fa-dashboard"></i><span>Sales Engineers Performance</span></a></li>
                 <li class="active"><a href="SalesManagerInfo.jsp"><i class="fa fa-dashboard"></i><span>Sales Manager Performance</span></a></li>
				 <li><a href="DisionInfo.jsp"><i class="fa fa-line-chart"></i><span>Sub Division Performance</span></a></li>
				 <li><a href="CompanyInfo.jsp?empcode=${DFLTDMCODE}"><i class="fa fa-pie-chart"></i><span>Division 	Performance</span></a></li>
				 <li><a href="SipUserActivity"><i class="fa fa-table"></i><span>SE Activity History</span></a></li>
<!-- 				 <li><a href="SipJihDues"><i class="fa fa-table"></i><span>JIH Dues</span></a></li> -->
<!-- 				 <li><a href="SipLOIDues"><i class="fa fa-table"></i><span>LOI Dues</span></a></li> -->
				 <li><a href="SipStageFollowUpController"><i class="fa fa-database"></i><span>Stage Follow-Up</span></a></li>  
				 <li><a href="sipWeeklyReport"><i class="fa fa-bar-chart"></i><span>Weekly-Sales Report</span></a></li> 
				 <li><a href="ProjectStatus"><i class="fa fa fa-bars"></i><span>Project Status</span></a></li> 
				 <li><a href="homepage.jsp"><i class="fa fa-home"></i><span>HR Portal</span></a></li>
               </c:when>
               <c:when test="${fjtuser.salesDMYn ge 1 and fjtuser.sales_code ne null}">
                <c:if test="${fjtuser.role eq 'gm'}">
      		 	<li><a href="SipBranchPerformance"><i class="fa fa-building-o"></i><span>Branch Performance</span></a></li>
      			</c:if>
                 <li><a href="DmInfo.jsp"><i class="fa fa-dashboard"></i><span>Sales Engineers Performance</span></a></li>
                 <c:if test="${isAllowed eq 'Yes' || fjtuser.salesDMYn ge 1}">
      		 		<li class="active"><a href="SalesManagerInfo.jsp"><i class="fa fa-building-o"></i><span>Sales Manager Performance</span></a></li>
      			</c:if>
				 <li><a href="DisionInfo.jsp"><i class="fa fa-line-chart"></i><span>Sub Division Performance</span></a></li>
				 <li><a href="CompanyInfo.jsp?empcode=${DFLTDMCODE}"><i class="fa fa-pie-chart"></i><span>Division 	Performance</span></a></li>
				 <li><a href="SipUserActivity"><i class="fa fa-table"></i><span>SE Activity History</span></a></li>
<!-- 				 <li><a href="SipJihDues"><i class="fa fa-table"></i><span>JIH Dues</span></a></li> -->
<!-- 				 <li><a href="SipLOIDues"><i class="fa fa-table"></i><span>LOI Duesgh</span></a></li> -->
 				<li><a href="ProjectStatus"><i class="fa fa fa-bars"></i><span>Project Status</span></a></li> 
				 <li><a href="SipStageFollowUpController"><i class="fa fa-database"></i><span>Stage Follow-Up</span></a></li> 
				 <li><a href="sipWeeklyReport"><i class="fa fa-bar-chart"></i><span>Weekly-Sales Report</span></a></li>				
				 <li><a href="homepage.jsp"><i class="fa fa-home"></i><span>HR Portal</span></a></li>  
               </c:when>
               <c:otherwise>
				  <li><a href="DmInfo.jsp"><i class="fa fa-dashboard"></i><span>Sales Engineers Performance</span></a></li>
				  <c:if test="${isAllowed eq 'Yes' || fjtuser.salesDMYn ge 1}">
      		 		<li class="active"><a href="SalesManagerInfo.jsp"><i class="fa fa-building-o"></i><span>Sales Manager Performance</span></a></li>
      		 	  </c:if>  
<!-- 				  <li><a href="SipJihDues"><i class="fa fa-table"></i><span>JIH Dues</span></a></li> -->
<!-- 				  <li><a href="SipLOIDues"><i class="fa fa-table"></i><span>LOI Duesgh</span></a></li> -->				  
				  <li><a href="ProjectStatus"><i class="fa fa fa-bars"></i><span>Project Status</span></a></li>
				  <li><a href="SipStageFollowUpController"><i class="fa fa-database"></i><span>Stage Follow-Up</span></a></li>
				  <li><a href="sipWeeklyReport"><i class="fa fa-bar-chart"></i><span>Weekly-Sales Report</span></a></li>  
				  <li><a href="homepage.jsp"><i class="fa fa-home"></i><span>HR Portal</span></a></li>
               </c:otherwise>               
              </c:choose>
              </ul>
    </section>
    <!-- /.sidebar -->
  </aside>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper" style="margin-top: -8px;">
    <!-- Content Header (Page header) -->
   <!--  <section class="content-header">
      <h1>
      ${selected_salesman_code}- 
        <small>Sales Egr. Performance Dashboard</small>
      </h1>
     
    </section>--> 

    <!-- Main content -->
    <div class="row">
    <div class="col-md-8 form-group">
<form class="form-inline" method="post" action="sip"> 
    <br/>
    <c:set var="sales_egr_code" value="${selected_salesman_code}" scope="page" /> 

    <select class="form-control form-control-sm select2" name="scode" id="scode" required onchange="sm_performance_booking()">
        <c:if test="${fjtuser.role ne 'mg' and fjtuser.salesDMYn eq 0}">  
            <option value="${fjtuser.emp_code}" ${fjtuser.emp_code == selected_salesman_code ? 'selected':''}>${fjtuser.uname}</option>
        </c:if>
        <c:if test="${fjtuser.role eq 'mg' or fjtuser.salesDMYn ge 1}">  
            <option value="0">Select Sales Manager</option>
        </c:if>
        <c:forEach var="s_engList" items="${SEngLst}">
            <c:choose>
                <c:when test="${fjtuser.role eq 'mg'}">
                    <option value="${s_engList.salesman_emp_code}" ${s_engList.salesman_emp_code == selected_salesman_code ? 'selected':''}>${s_engList.salesman_name}</option>
                </c:when>
                <c:when test="${fjtuser.salesDMYn ge 1 and fjtuser.role ne 'mg'}">
                    <option value="${s_engList.salesman_emp_code}" ${s_engList.salesman_emp_code == selected_salesman_code ? 'selected':''}>${s_engList.salesman_name}</option>
                </c:when>
                <c:otherwise>
                    <option value="${s_engList.salesman_emp_code}" ${s_engList.salesman_code == selected_salesman_code ? 'selected':''} role="${s_engList.salesman_code}">${s_engList.salesman_name} -(${s_engList.salesman_code})</option>
                </c:otherwise> 
            </c:choose>
        </c:forEach>
    </select>
    
    <input type="hidden" name="fjtco" value="salesChart" />

    <button type="button" id="seperfdiv" class="btn btn-sm btn-primary" onclick="sm_performance_details();">
        <i class="fa fa-share" aria-hidden="true"></i> PERFORMANCE
    </button>
</form>


</div>




</div>

<script>
    google.charts.setOnLoadCallback(function() { drawGuageGraph(${actual}, ${guage_bkng_ytd_target}, 'guage_test_booking', 'Booking'); });
    google.charts.setOnLoadCallback(function() { drawGuageGraph(${actualbl}, ${guage_blng_ytd_target}, 'guage_test_billing', 'Billing'); });
</script>



          
<div class="container">
    <div class="row">
        <!-- Second Section (Now First) -->
        <div class="col-lg-5 col-md-12">
            <section style="margin-top: 2px;border-top: 3px solid #9e9e9e;width:100%;height:274px; border-radius: 3px;margin-bottom: 5px;">
                <div class="nav-tabs-custom">
                    <div class="tab-content">
                        <div id="bb1-meter" class="tab-pane fade in active">
                            <div class="row">     
                                <div class="box-header with-border" style="margin-top: -10px;"> 
                                    <h3 class="box-title">Target Vs Actual Achieved % for ${syrtemp} -
                                        <c:choose>
                                            <c:when test="${syrtemp lt CURR_YR}">
                                                (FY)
                                            </c:when>
                                            <c:otherwise>        
                                                (YTD)
                                            </c:otherwise>
                                        </c:choose>
                                    </h3>
                                    <style>
                                        .bg-color-1 {
                                            background-color: #ff9999;
                                            padding: 2px;
                                            border-radius: 4px;
                                        }

                                        .bg-color-3 {
                                            background-color: #99ff99;
                                            padding: 2px;
                                            border-radius: 4px;
                                        }

                                        .align-right {
                                            display: inline-block;
                                            text-align: right;
                                            width: 60px;
                                        }

                                        #guage_test_booking, #guage_test_billing {
                                            box-sizing: border-box;
                                            width: 100%;
                                            height: 120px;
                                        }

                                        @media (max-width: 768px) {
                                            #guage_test_booking, #guage_test_billing {
                                                height: 130px;
                                            }

                                            .align-right {
                                                width: auto;
                                            }
                                        }
                                    </style>
                                    <h6>
                                       &nbsp;  &nbsp;   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        <span class="bg-color-1">Booking Target: <span class="align-right" id="bookingTargetValue">0</span></span>
                                        &nbsp; &nbsp; || &nbsp; &nbsp;
                                        <span class="bg-color-3">Billing Target: <span class="align-right" id="billingTargetValue">0</span></span>
                                    </h6>

                                    <h6>
                                     &nbsp; &nbsp;   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
                                        <span class="bg-color-1">Booking Actual: <span class="align-right" id="bookingActualValue">0</span></span>
                                        &nbsp; &nbsp; || &nbsp; &nbsp;
                                        <span class="bg-color-3">Billing Actual: <span class="align-right" id="billingActualValue">0</span></span>
                                    </h6>
                                </div>
                                <div class="row">
                                    <div class="col-lg-1 col-xs-0"></div>
                                    <div class="col-lg-5 col-xs-6 sep">
                                        <div id="guage_test_booking" style="background: linear-gradient(to bottom, transparent 20px, #ff9999 20px); padding: 1px; box-sizing: border-box; height: 185px; margin-top:-20px"></div>
                                    </div>
                                    <div class="col-lg-5 col-xs-6">
                                        <div id="guage_test_billing" style="background: linear-gradient(to bottom, transparent 20px, #99ff99 20px); padding: 1px; box-sizing: border-box; height: 185px; margin-top:-20px"></div>
                                    </div>
                                    <div class="col-lg-1 col-xs-0"></div>
                                </div>
                            </div>
                                  <div id="performance_container" style="margin-left: 40px;"></div>

                        </div>
                    </div>
                </div>
               
            </section>
        </div>
<style>
.small-box {
    position: relative;
    /* Add other styles as needed */
}

.small-box-footer {
    display: block;
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    background-color: #f39c12; /* Match the background color of the .small-box */
    color: white; /* Ensure text is visible */
    text-align: center;
    padding: 10px;
    box-sizing: border-box;
    /* Add other styles as needed */
}

</style>
<style>
#performance_container .row {
    margin-left: 0;
    margin-right: 0;
}

#performance_container .col-sm-6 {
    padding-left: 25px;
    padding-right: 5px;
    margin-left: -10px;
}
#performance_container .btn {
    letter-spacing: 1px; /* Adjust the spacing between letters */
}


/* Additional styles for responsiveness */
@media (max-width: 576px) {
    #performance_container .col-sm-6 {
        margin-left: 0;
        margin-bottom: 10px; /* Ensure spacing is adequate on small screens */
    }
    /* Ensure proper spacing and prevent overlap */
 /* Flexbox layout for header and icons */

</style>
        <!-- First Section (Now Second) -->
       <!-- First Section (Now Second) -->
<div class="col-lg-5 col-md-12">
    <section class="stage-details-section">
        <div class="nav-tabs-custom">
            <div class="tab-content">
                <div class="box-header with-border d-flex justify-content-between align-items-center" style="margin-top: -10px;">
                    <h3 class="box-title">STAGE DETAILS</h3>
                    <div class="d-flex align-items-center">
                        <div class="stage-details-graph" id="openModalBtn">
                            <i class="fa fa-bar-chart fa-1x"></i>
                        </div>
                        <div class="help-right ml-2" id="help-stages">
                            <i class="fa fa-info-circle"></i>
                        </div>
                    </div>
                </div>
                <div id="stages-dt" class="tab-pane fade in active">
                    <div class="row">
                        <div class="col-lg-6 col-xs-6">
                            <div class="small-box bg-red">
                                <div class="inner">
                                    <h3>Stage 2</h3>
                                    <p id="Stage2"><strong>0</strong></p>
                                </div>
                                <div class="icon"><i class="fa fa-pie-chart"></i></div>
                                <a href="#" onclick="s2Details();" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
                            </div>
                        </div>
                        <div class="col-lg-6 col-xs-6">
                            <div class="small-box bg-yellow">
                                <div class="inner">
                                    <h3>Stage 3</h3>
                                    <p id="Stage3"><strong>0</strong></p>
                                </div>
                                <div class="icon"><i class="fa fa-pie-chart"></i></div>
                                <a href="#" onclick="s3Details();" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-2">
                        <div class="col-lg-6 col-xs-6">
                            <div class="small-box bg-blue">
                                <div class="inner">
                                    <h3>Stage 4</h3>
                                    <p id="Stage4"><strong>0</strong></p>
                                    <input type="hidden" id="s3sum_temp" value="0" />
                                </div>
                                <div class="icon"><i class="fa fa-pie-chart"></i></div>
                                <a href="#" onclick="s4Details();" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
                            </div>
                        </div>
                        <div class="col-lg-6 col-xs-6">
                            <div class="small-box bg-green">
                                <div class="inner">
                                    <h3>Stage 5</h3>
                                    <p id="Stage5"><strong>0</strong></p>
                                    <input type="hidden" id="s4sum_temp" value="0" />
                                </div>
                                <div class="icon"><i class="fa fa-pie-chart"></i></div>
                                <a href="#" onclick="s5Details();" class="small-box-footer">More info <i class="fa fa-arrow-circle-right"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<style>
    .stage-details-section {
        border-top: 3px solid #9e9e9e;
        width: 90%;
        height: 274px;
        border-radius: 3px;
        margin-bottom: 5px;
    }

    @media (max-width: 576px) { /* Adjust based on your mobile breakpoint */
        .stage-details-section {
            margin-top: 70px; /* Apply margin-top on mobile screens only */
        }
    }
</style>
       
    </div>
</div>
 

	
	  <div class="modal fade" id="salesmanager_performance_modal" role="dialog"> 			  
			<div class="modal-dialog modal-lg">							
				<div class="modal-content"  style="height: max-content !important;width:100%;"> 
					<div class="modal-header">
								         	 <button type="button" class="close" data-dismiss="modal">&times;</button>
								          		<h4 class="modal-title"  id="sm_h1"> </h4>	
								          		<h5 class="modal-subtitle"  id="sm_h1"> </h5>	
								          		<h5 class="modal-subtitle3"  id="sm_h1"> </h5>					          		
					 </div>  
					<div class="modal-body">										
					</div>
					<div class="modal-footer" style="text-align:left">
                    <c:forEach var="s_engList" items="${SEngLst}"> 
<%-- 					               <span onclick="showSalesEngineerPerf('${s_engList.salesman_code}');"><a href >${s_engList.salesman_name}</a></span>       --%>
					              <a href ="#" data-backdrop='static' data-keyboard='false' class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal-default1' onclick="showSalesEngineerPerf('${s_engList.salesman_code}','${s_engList.salesman_name}');">${s_engList.salesman_name}</a>                        
                            </c:forEach>     
					     
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					</div>
				</div>
		 </div>
	</div>
	
		  <div class="modal fade" id="salesman_performance_modal" role="dialog" style="width: 80%;"> 			  
			<div class="modal-dialog modal-lg" >							
				<div class="modal-content"  style="height: max-content !important;width:100%;"> 
					<div class="modal-header">
								         	 <button type="button" class="close" data-dismiss="modal">&times;</button>
								          		<h4 class="modal-title"  id="sm_h1"> </h4>
								          		<h5 class="modal-subtitle"  id="sm_h1"> </h5>	
								          		<h5 class="modal-subtitle2"  id="sm_h1"> </h5>								          		
					 </div>  
					<div class="modal-body">										
					</div>
					<div class="modal-footer">   
					     
						<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
					</div>
				</div>
		 </div>
	</div>
	
	<div class="modal fade" id="help-modal"  role="dialog" style="width: 80%;">
		 <div class="modal-dialog  modal-sm"  >
			<div class="modal-content" style="height:min-content;width: max-content !important;">
				 <div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					 <h4 class="modal-title">Conversion Ratio Help</h4>
					 </div>
					<div class="modal-body">
							<font  color="#0c3d6d" style="padding-left:20px"> (<b>4.</b> STG2_STG4_AMT)</font>
							    / 
							<font  color="#cd3f15">  (<b>1.</b>  STG2_6MTH_AMT+ 
							   <b>2.</b> STG2_LOST_AMT+
							   <b>3.</b> STG2_HOLD_AMT+
							   <b>4.</b> STG2_STG4_AMT</font>
							   ) * 100
							<br/><br/>
							
					    <ol>					    	
							 <li><font color="#0000ff"><b> STG2_6MTH_AMT </b></font>  Quotations where <b>AGING >6Mths</b> and <b>Quotation     
							                   date >= '01-JAN-2022'</b>, in job in hand stage,  
							                   not marked as lost
							</li>
							 <li><font color="#ff9900"><b>STG2_LOST_AMT</b></font>   quotation marked as Lost from job in hand, 
							                   without duplicate as reason, <b>Quotation date 
							                   >= '01-JAN-2022'</b>
							</li>
							 <li><font color="#3b80a9"><b>STG2_HOLD_AMT</b></font>   Quotation marked as Hold and <b>Quotation date 
							                   >= '01-JAN-2022'</b>
							</li>
							 <li><font color="#008000"><b>STG2_STG4_AMT</b></font>   <b>SO_date >= '01-JAN-2022'</b> and so referred from 
				                   quotation and referred <b>Quotation date >= '01-
				                   JAN-2022'</b>
							</li>
						 </ol>              
					 </div>
									<div class="modal-footer">
										<button type="button" class="btn btn-default pull-left"
											data-dismiss="modal">Close</button>

									</div>
								</div>
								<!-- /.modal-content -->
							</div>
							<!-- /.modal-dialog -->
						</div>
	<div class="modal fade" id="help-modaljihnoresp"  role="dialog" >
		 <div class="modal-dialog  modal-sm"  >
			<div class="modal-content" style="height:min-content;width: max-content !important;">
				 <div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					 <h4 class="modal-title">Help</h4>
					 </div>
					<div class="modal-body">							
							<font  color="#cd3f15"> </font>
							   <b> JIH lost with No Response  </b> should be <b>10% </b>or  less than of <b>Total JIH lost.</b>
							<br/><br/>
					 </div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default pull-left"
								data-dismiss="modal">Close</button>

						</div>
					</div>
								<!-- /.modal-content -->
				</div>
							<!-- /.modal-dialog -->
			</div>
	<div class="modal fade" id="help-modalfor120days"  role="dialog" >
		 <div class="modal-dialog  modal-sm"  >
			<div class="modal-content" style="height:min-content;width: max-content !important;">
				 <div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					 <h4 class="modal-title">Help</h4>
					 </div>
					<div class="modal-body">							
							<font  color="#cd3f15"> </font>
							   Outstanding <b>>120 days </b> should be <b>5%</b> or less than of <b>YTD Billing</b>
							<br/><br/>
					 </div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default pull-left"
								data-dismiss="modal">Close</button>

						</div>
					</div>
								<!-- /.modal-content -->
				</div>
							<!-- /.modal-dialog -->
			</div>

			<div class="modal fade" id="s5-modal-graph" role="dialog" >
			
			        <div class="modal-dialog" style="width:97%;">
			     		<!-- Modal content-->
					      	<div class="modal-content">
						        	<div class="modal-header">
						         	 <button type="button" class="close" data-dismiss="modal">&times;</button>
						          		<h4 class="modal-title">Billing Details </h4>
						        	</div>
						        	<div class="modal-body small"> </div>
							        <div class="modal-footer">
							          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
							        </div>
						     </div>
				   	 </div>   	 		   	 
 			</div>

		 	<div class="modal fade" id="s3-modal-graph" role="dialog" >
                  <div class="modal-dialog" style="width:97%;">
                           <!-- Modal content-->
                        <div class="modal-content">
                              <div class="modal-header">
                               <button type="button" class="close" data-dismiss="modal">&times;</button>
                                     <h4 class="modal-title">Booking Details </h4>
                              </div>
                              <div class="modal-body small"> </div>
                               <div class="modal-footer">
                                 <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                               </div>
                         </div> 
                  </div>  
          </div>

          <div class="modal fade" id="s4-modal-graph" role="dialog" >					
		        <div class="modal-dialog" style="width:97%;">
		     		<!-- Modal content-->
				      	<div class="modal-content">
					        	<div class="modal-header">
					         	 <button type="button" class="close" data-dismiss="modal">&times;</button>
					          		<h4 class="modal-title">Billing Details </h4>
					        	</div>
					        	<div class="modal-body small"> </div>
						        <div class="modal-footer">
						          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						        </div>
					     </div>
			   	 </div>   	 		   	 
		  </div>
		  <div class="modal fade" id="jihv-modal-graph" role="dialog" >					
			        <div class="modal-dialog" style="width:97%;">
			     		<!-- Modal content-->
					      	<div class="modal-content">
						        	<div class="modal-header">
						         	 <button type="button" class="close" data-dismiss="modal">&times;</button>
						          		<h4 class="modal-title">Job In Hand Volume Details </h4>
						        	</div>
						        	<div class="modal-body small"> <div id="table_div"></div></div>
							        <div class="modal-footer">
							          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
							        </div>
						     </div>
				   	 </div>   	 		   	 
 			</div>
	  
<div id="myModal" class="modal">
<div class="modal-content" style="width: 25%; height: 40%; margin-left: auto; margin-right: 25%;margin-top: 10%;"> 
<div class="modal-header"> 
<button type="button" class="close" data-dismiss="modal">&times;</button>
<h4 class="modal-title">Stage details of Sales Engineer - ${selected_salesman_code} </h4>
</div> 
<div class="modal-body"> <div id="stagedetailsgraph"></div></div>
</div>
</div>
<div class="row">
<div class="modal fade" id="rcvbles_aging_modal-main" role="dialog" >
<div class="modal-dialog" style="width:97%;">
<!-- Modal content-->
<div class="modal-content">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal">&times;</button>
<h4 class="modal-title"> </h4>
</div>
<div class="modal-body small"> <div id="table_div"></div></div>
<div class="modal-footer"><div id="laoding-rcvbl" class="loader" ><img src="resources/images/wait.gif"></div>
<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
</div>
</div>
</div> 
</div>
</div> 
<div class="modal fade" id="help-stages-modal">
<div class="modal-dialog" style="width: 80%;">
<div class="modal-content">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal" aria-label="Close">
<span aria-hidden="true">&times;</span>
</button>
<h4 class="modal-title">Stage Details Help</h4>
</div>
<div class="modal-body">
<ul>
<li>
<p class="font-weight-bold">Stage Details - Last two years data</p>
</li>
<li>
<h4 class="font-weight-bold text-primary">Stage-1</h4>
<p class="font-weight-bold">These are the quotations which are in tender stage processed against an enquiry.</p>
</li>
<li>
<h4 class="font-weight-bold text-primary">Stage-2</h4>
<p class="font-weight-bold">These are the quotations which are job-in-hand but does not have LOI Date.</p> 
</li>
<li>
<h4 class="font-weight-bold text-primary">Stage-3</h4>
<p class="font-weight-bold">These are the quotations against which LOI is received with date.</p>
</li>
<li>
<h4 class="font-weight-bold text-primary">Stage-4</h4>
<p class="font-weight-bold">It is Order confirmation entry in ERP , ( Customer po )</p>
</li> 
</ul>
</div>
<div class="modal-footer">
<button type="button" class="btn btn-default pull-left"
data-dismiss="modal">Close</button>
</div>
</div>
<!-- /.modal-content -->
</div>
<!-- /.modal-dialog -->
</div> 

	  

  <!-- /.content-wrapper -->
<!--   <footer class="main-footer">
    <div class="pull-right hidden-xs">
      <b>Version</b> 2.0.0
    </div>
    <strong>Copyright &copy;  1988 - ${CURR_YR} <a href="http://www.faisaljassim.ae/">Faisal Jassim Group</a>.</strong> All rights
    reserved.
  </footer> -->

  <!-- Control Sidebar -->
  <!--  <aside class="control-sidebar control-sidebar-dark">
    <!-- Create the tabs -->
  <!-- <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
      <li><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li>
      <li><a href="#control-sidebar-settings-tab" data-toggle="tab"><i class="fa fa-gears"></i></a></li> 
    </ul>--> 
    <!-- Tab panes 
    
  </aside>-->
  <!-- /.control-sidebar -->
  <!-- Add the sidebar's background. This div must be placed
       immediately after the control sidebar -->
  <div class="control-sidebar-bg"></div>

</div>
<!-- ./wrapper -->
</div>
<!-- jQuery 3 -->

<!-- Bootstrap 3.3.7 -->

<!-- ChartJS -->

<!-- FastClick -->
<script src="resources/bower_components/fastclick/lib/fastclick.js"></script>
<!-- AdminLTE App -->
<script src="resources/dist/js/adminlte.min.js"></script>
<script src="resources/bower_components/select2/dist/js/select2.full.min.js"></script>
<script src="resources/js/date-eu.js"></script>

<div id="StageGraph5" style="display: none;"></div>
<div id="StageGraph3" style="display: none;"></div>
<div id="StageGraph4" style="display: none;"></div>
<div id="StageGraph2" style="display: none;"></div>
	 
		 <script>
		 $(document).ready(function () {
			    // Open the modal and display a graph with random values
			    $('#openModalBtn').click(function () {
			        $('#myModal').modal('show');
			        
			       // Random data for the chart
			        var s2Data = parseFloat(document.getElementById('StageGraph2').innerHTML) || 	1;
                    var s3Data = parseFloat(document.getElementById('StageGraph3').innerHTML) || 1;
                    var s4Data = parseFloat(document.getElementById('StageGraph4').innerHTML) || 1;
                    var s5Data = parseFloat(document.getElementById('StageGraph5').innerHTML) || 1;

 
			      /*   var s2Data = document.getElementById('StageGrahp2').innerHTML;
			        var s3Data = document.getElementById('StageGraph3').innerHTML;
			        var s4Data = document.getElementById('StageGraph4').innerHTML;
			        var s5Data = document.getElementById('StageGrahp5').innerHTML;

			      */   // Draw the chart with the random data
			        drawChart(s2Data, s3Data, s4Data, s5Data);
			    });

			    // Attach click event listener to close modal button
			    document.getElementsByClassName('close')[0].addEventListener('click', function() {
			        // Hide the modal
			        document.getElementById('myModal').style.display = 'none';
			    });

			    // Function to draw the Google Chart
			    function drawChart(s2Data, s3Data, s4Data, s5Data) {
			        var data = google.visualization.arrayToDataTable([
			            ['Sales Engineer', 'Stages', { role: 'style' }, { role: 'annotation' }],
			            ['S2', s2Data, '#dd4b39', new Intl.NumberFormat('en-US', { style: 'decimal', maximumFractionDigits: 2 }).format(s2Data / 1000000)],
			            ['S3', s3Data, '#f39c12', new Intl.NumberFormat('en-US', { style: 'decimal', maximumFractionDigits: 2 }).format(s3Data / 1000000)],
			            ['S4', s4Data, '#0073b7', new Intl.NumberFormat('en-US', { style: 'decimal', maximumFractionDigits: 2 }).format(s4Data / 1000000)],
			            ['S5', s5Data, '#00a65a', new Intl.NumberFormat('en-US', { style: 'decimal', maximumFractionDigits: 2 }).format(s5Data / 1000000)]
			        ]);

			        var options = {
			            vAxis: { minValue: 0, title: 'Amount', titleTextStyle: { color: '#333' }, format: 'short' },
			            legend: { position: 'top' },
			            colors: ['#FF5733', '#3498DB', '#F1C40F', '#27AE60']
			        };

			        var chart = new google.visualization.ColumnChart(document.getElementById('stagedetailsgraph'));
			        chart.draw(data, options);
			    }

			    // Show help stages modal when 'help-stages' is clicked
			    $('#help-stages').click(function () {
			        $('#help-stages-modal').modal('show');
			    });
			});



</script>

<script>
     

function showSalesEngineerPerf(salesCode,smName,smPage) {
	$('#laoding').show(); 
	var smCodeName,smCode;
	var currWeek = ${currWeek};
	if(smPage == "1"){
		smCodeName = smName;
		smCode = salesCode; 
		var exTtl = 'Salesman Performance - '+smName;
		var ttl = 'Salesman Performance '+smName;
	}else{
	 smCodeName = $("#scode option:selected").text(); 
	 smCode = $("#scode option:selected").val(); 
	 var exTtl = 'Salesman Performance - '+smName+' - ('+salesCode+')';
	 var fileName = 'Salesman Performance '+smName+' - ('+salesCode+')';
	 var subTtl = 'Current week - '+${currWeek}  + ' and Year - '+${CURR_YR};
	 var printttl = 'Salesman Performance '+smCodeName +'<br/>  Week - '+${currWeek} + ' and Year - '+${CURR_YR} +'<br/>';
	 var ttl = 'Sales Manager Performance '+smCodeName +' and Current week - '+${currWeek}  + ' and Year - '+${CURR_YR};
	}
	
	 $("#salesman_performance_modal .modal-title").html(smName);  
	 $("#salesman_performance_modal .modal-subtitle").html(subTtl);
	
	$("#salesman_performance_modal .modal-title").html(exTtl);
	$.ajax({ 
	type: 'POST',
	url: 'salesManagerPerf',  
 	data :{
 			fjtco:"se_perf" ,
 			c1 : salesCode
 			},
	dataType: "json",
	 
	success : function(data){
		$('#laoding').hide();
		var outrecv = 0, bookingTarget = 0, bookingActual = 0, gpTarget = 0, gpActual = 0,  billingTarget = 0, billingActual = 0, prcntgeBilling = 0, stage2JIH = 0, stage3LOI = 0, stage4LPO = 0, stage5LOI = 0, weekBkTarget = 0, prcntgeBooking = 0,  prcntgeBilling = 0 , prcntgeGp = 0;
		var ytdTargetBkng = 0, ytdTargetBlng = 0 , ytdTargetGp = 0 , ytdPrcntgeBkng = 0, ytdPrcntgeBlng = 0, ytdPrcntgeGp = 0, weekBlngTarget,  stage1TENDER = 0, stage3LOI = 0, actualweeklyBilling = 0 , actualweeklyBooking = 0, totalstage3and4 = 0 , stage3and4vsyearlybillingtarget = 0,converratio=0;
		var aging30 = 0, aging3060 = 0 , aging6090 = 0, aging90120 = 0,aging120180 = 0,aging181 = 0, aging90 = 0 , aging120 = 0;
		var ytdVistactuals = 0,ytdVisttarget = 0, totJIHLostVal = 0 ,JIHLostNoRepse = 0,ytdCustVistit = 0,avgweeklyorders=0;	
		
		for(var i in data){				
		switch ($.trim(data[i].srNo)) {
		  case "1.0": // total billing target
			  billingTarget = data[i].yrTot;
		    break; 
		  case "1.1": // billing gp target
			  gpTarget = data[i].yrTot;
		  case "1.2": // weekly billing target
			  weekBlngTarget = data[i].yrTot;
		    break; 
		  case "1.3": // actual weekly Billing
			  actualweeklyBilling = data[i].yrTot;
		    break; 
		  case "1.4": // YTD Billing target
			  ytdTargetBlng = data[i].yrTot;
		    break; 
		  case "1.5": // YTD Billing GP target
			  ytdTargetGp = data[i].yrTot;
		    break; 
		  case "2.0":// Total Booking Target
			  bookingTarget = data[i].yrTot;
		    break; 
		  case "2.1": // Weekly Booking Target
			  weekBkTarget = data[i].yrTot;
		    break; 
		  case "2.2": // actual weekly booking
			  actualweeklyBooking = data[i].yrTot;
		    break; 
		  case "2.3": // YTD Booking Target
			  ytdTargetBkng = data[i].yrTot;
		    break; 
		  case "3": // STAGE 1(Tender)
			  stage1TENDER = data[i].yrTot;
		    break;
		  case "3.1": // STAGE 2(JIH)
			  stage2JIH = data[i].yrTot;
		    break;
		  case "4": // STAGE3 (LOI)
			  stage3LOI = data[i].yrTot;
			  bookingActual = data[i].yrTot;
		    break;
		  case "4.1": // YTD Booking Perc
			  ytdPrcntgeBkng = data[i].yrTot; 		 
		    break;
		  case "5": // STAGE3 (LOI)
			  stage3LOI = data[i].yrTot;
		    break;
		  case "5.1": // Stage 4 (LPO)
			  stage4LPO = data[i].yrTot;
		    break;
		  case "5.2": // total stage 3 & 4
			  totalstage3and4 = data[i].yrTot;
		    break;
		  case "5.3": // Stage 3 & 4 vs yearly billing target
			  stage3and4vsyearlybillingtarget = data[i].yrTot;
		    break;
		  case "5.4": //average weekly orders(s4)
			  avgweeklyorders = data[i].yrTot;
		    break;
		  case "6": // stage 5 ytd
			  stage5LOI = data[i].yrTot;
			  billingActual = data[i].yrTot;
		    break;
		  case "6.1": 
			  gpActual = data[i].yrTot;
		    break; 
		  case "6.2":
			  ytdPrcntgeBlng = data[i].yrTot;
		    break; 
		  case "7": 
			  outrecv = data[i].yrTot;
	       break; 
		  case "8": // Conversion Ratio
			  converratio = data[i].yrTot;
		  break;
		  case "9": // Conversion Ratio
			  ytdVistactuals = data[i].yrTot;
		  break;
		  case "9.1": // Conversion Ratio
			  ytdVisttarget = data[i].yrTot;
		  break;
		  case "10": // total JIH LOST VALUE
			  totJIHLostVal = data[i].yrTot;
		  break;
		  case "10.1": // total JIH LOST VALUE with no reason
			  JIHLostNoRepse = data[i].yrTot;
		  break;
		  case "222": 	
			  aging30 = +data[i].aging_1;			  
			  aging3060 = +data[i].aging_2; 
			  aging6090 = +data[i].aging_3;			  
			  aging90120 = +data[i].aging_4;
			  aging120180 = +data[i].aging_5;
			  aging181 = +data[i].aging_6; 
			  aging90 = aging30 + aging3060 + aging6090;
			  aging120 =  aging120180 + aging181;
		  break;
		  default:
			     break;
		}
	} 
		
		prcntgeBooking = percentageCal(bookingActual, bookingTarget);
		//ytdPrcntgeBkng = percentageCal(bookingActual, ytdTargetBkng);
		prcntgeBilling = percentageCal(billingActual, billingTarget);
		ytdPrcntgeBlng = percentageCal(billingActual, ytdTargetBlng);
		ytdCustVistit = percentageCal(ytdVistactuals,(ytdVisttarget*currWeek));
		prcntgeGp = percentageCal(gpActual, gpTarget);
		ytdPrcntgeGp = percentageCal(gpActual, ytdTargetGp);
		if(ytdPrcntgeBkng >= 100){
			percentageachievedbooking = 100;
		}else{
			percentageachievedbooking = Math.round(percentageCal(ytdPrcntgeBkng,100));
		}
		if(ytdPrcntgeBlng >= 100){
			percentageachievedbilling = 100;
		}else{
			percentageachievedbilling = Math.round(percentageCal(ytdPrcntgeBlng,100));
		}
		if(ytdCustVistit >= 100){
			percentageachievedcustvisit = 100;
		}else{
			percentageachievedcustvisit = Math.round(percentageCal(ytdCustVistit,100));
		}
		if(ytdPrcntgeGp >= 100){
			percentageachievedgeGp = 100;
		}else{
			percentageachievedgeGp =  Math.round(percentageCal(ytdPrcntgeGp,100));
		}
		
		var jihpercentage = totJIHLostVal !== 0 ? (JIHLostNoRepse / totJIHLostVal) * 100 : 0;
		if (totJIHLostVal == 0 && JIHLostNoRepse == 0) {
		    jihpercentage = 0; 
		}
		if(jihpercentage <= 10){
			jihpercentageval= 10;
		}else{
			jihpercentageval=0;
		}
		var billing120actual = aging90120 + aging120180 + aging181;		
		var billingactual = (billing120actual/billingActual)*100;
		
		if(billingactual <= 5){
			billingactualtotalper= 20;
		}else{
			billingactualtotalper=0;
		}
		//const showUpdateBtn = (getSalesEngineerDetails(data[i].seCode)[0].salesman_emp_code === loggedEmp) ? true : false; 
		var output= "<table id='salesman_performance_table' style='text-align:center; margin-left: auto; margin-right: auto;width: auto;'><thead ><tr>"
    		   +"<th class='se-brr'>Performance Title</th><th>Yearly Target</th><th>YTD Target</th><th>Actual</th><th>Yearly %</th><th>YTD %</th><th>% Achieved </th><th>Weightage</th><th>Total %</th></tr></thead><tbody>";
    	output+="<tr><td style='text-align:left;'class='se-brr'>Tender</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage1TENDER))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>JIH</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage2JIH))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				// +	"<tr><td style='text-align:left;'class='se-brr'>Stage-3(LOI)</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage3LOI))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"				 
				//+	"<tr><td style='text-align:left;' class='se-brr'>STAGE-5-(BILLING) </td><td class='se-blr'></td><td style='text-align:right;'></td><td style='text-align:right;'>"+formatNumber(stage5LOI)+ "</td><td></td></tr>"
				 +  "<tr><td style='text-align:left;' class='se-brr'>Booking </td><td style='text-align:right;'>"+formatNumber(Math.round(bookingTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetBkng))+"</td><td style='text-align:right;'>"+ formatNumber(Math.round(stage3LOI)) + "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' data-toggle='modal' data-target='#modal-default1' onclick='printAllSalesEngineerBookingCodes(\""+$.trim(data[i].smCode)+"\", \"SC\")'><i class='fa fa-file-excel-o' aria-hidden='true'></a></td><td>"+formatNumber(prcntgeBooking)+ "</td><td style='text-align:right;'>"+ytdPrcntgeBkng+ "</td><td style='text-align:right;'>"+percentageachievedbooking+ "</td><td style='text-align:right;'>"+10+ "</td><td style='text-align:right;'>"+(percentageachievedbooking*10)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Booking</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(actualweeklyBooking))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Orders</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage4LPO))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Orders</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(avgweeklyorders))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Billing</td><td style='text-align:right;'>"+formatNumber(Math.round(billingTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetBlng))+"</td><td style='text-align:right;background-color:#F08080;font-weight: bold'>"+ formatNumber(Math.round(billingActual))  + "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' data-toggle='modal' data-target='#modal-default1' onclick='printAllSalesEngineerBillingCodes(\""+$.trim(data[i].smCode)+"\", \"SC\")'><i class='fa fa-file-excel-o' aria-hidden='true'></i></a></td><td>"+formatNumber(prcntgeBilling)+ "</td><td style='text-align:right;'>"+ytdPrcntgeBlng+ "</td><td style='text-align:right;'>"+percentageachievedbilling+ "</td><td style='text-align:right;'>"+5+ "</td><td style='text-align:right;'>"+(percentageachievedbilling*5)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Billing</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(actualweeklyBilling))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Customer Visit</td><td>-</td><td style='text-align:right;'>"+formatNumber(ytdVisttarget*currWeek)+ "</td><td style='text-align:right;'>"+formatNumber(ytdVistactuals)+ "</td><td>-</td><td>"+formatNumber(ytdCustVistit)+"</td><td style='text-align:right;'>"+percentageachievedcustvisit+ "</td><td style='text-align:right;'>"+5+"</td><td style='text-align:right;'>"+(percentageachievedcustvisit*5)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Total JIH Lost</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(totJIHLostVal))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;width:35%;' class='se-brr'>JIH Lost with NR</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(JIHLostNoRepse))+ "</td><td>-</td><td>-</td><td>-</td><td style='text-align:right;'>"+10+"</td><td style='text-align:right;'><a href='#' data-toggle='modal' data-target='#help-modaljihnoresp'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a>"+jihpercentageval+"</td></tr>"
				 +  "<tr><td style='text-align:left;'class='se-brr'>Gross Profit</td><td style='text-align:right;'>"+formatNumber(Math.round(gpTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetGp))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(gpActual))+ "</td><td>"+formatNumber(prcntgeGp)+ "</td><td style='text-align:right;'>"+ytdPrcntgeGp+ "</td><td style='text-align:right;'>"+percentageachievedgeGp+ "</td><td style='text-align:right;'>"+50+ "</td><td style='text-align:right;'>"+(percentageachievedgeGp*50)/100+"</td></tr>"
				// +  "<tr><td style='text-align:left;font-weight: bold;' class='se-brr'>CONVERSION RATIO  <a href='#' data-toggle='modal' data-target='#help-modal'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a></td><td class='se-blr'></td><td>-</td><td>-</td><td style='text-align:right;font-weight: bold'>"+formatNumber(converratio)+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"			
				 //+	"<tr><td style='text-align:left;' class='se-bbr'></td><td style='text-align:left;' > <90 Days </td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(aging90))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				// +	"<tr><td style='text-align:left;' class='se-bbtr'>OUTSTANDING-RECV </td><td style='text-align:left;' > >90 Days </td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(aging90120))+"</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;background-color:#F08080;font-weight: bold;' >Outstanding-Recv >120 Days </td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='text-align:right;background-color:#F08080;font-weight: bold;'>"+formatNumber(Math.round(aging120))+"</td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='text-align:right;background-color:#F08080'>"+20+"</td><td style='text-align:right;background-color:#F08080'><a href='#' data-toggle='modal' data-target='#help-modalfor120days'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a>"+billingactualtotalper+"</td></tr>"
				 +	"<tr><td style='text-align:left;font-weight: bold;' > Total %</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td style='text-align:right;font-weight: bold;'>"+Math.round((((percentageachievedbooking*10)/100)+((percentageachievedbilling*5)/100)+((percentageachievedcustvisit*5)/100)+((percentageachievedgeGp*50)/100)+billingactualtotalper+jihpercentageval))+"</td></tr>";
 
    			output+="</tbody></table>"; 
    			var subTtl1 =  'Conversion Ratio - '+formatNumber(converratio) +"<a href='#' data-toggle='modal' data-target='#help-modal'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;padding-right: 670px;'></i></a>";
    			$("#salesman_performance_modal .modal-body").html(output);  
    			$("#salesman_performance_modal .modal-subtitle2").html(subTtl1);
    			$("#salesman_performance_modal").modal("show");
    	
    			$("#salesman_performance_table").DataTable( {
    				dom: 'Bfrtip',
    				searching: false,
    			    ordering:  false,
    			    paging: false,
    			    info: false,
    			     buttons: [
    			         {
    			            extend: 'excelHtml5',
    			             text:      '<i class="fa fa-file-excel-o" style="color: #1979a9; font-size: 1em;">Export</i>',
    			             filename: fileName,
    			             title: ttl,
    			             messageTop: 'File Processed on : ${currCal} ,The information in this file is copyright to Faisal Jassim Group.'
    			         },
    			         {
 			        	    extend: 'print', 
 			        	    text:      '<i class="fa fa-print" style="color: #1979a9; font-size: 1em;">Print</i>',  
 			        	    title: printttl + " Conversion Ratio: "+formatNumber(converratio),
 			        	    customize: (win) => {
 			        	    	$(win.document.head).append('<style>h1 { font-size: 14px; }</style>'); // Adjust the font size of the title
 			        	    	$(win.document.body)    			        	        
 	                            .css("height", "auto")
 		        	            .css("min-height", "0");
 			        	        $(win.document.body).find( 'table' )
 			                    .addClass( 'compact' )
 			                    .css( 'font-size', 'inherit' );
 			        	        $(win.document.body).find('table').css('border-collapse', 'collapse');
 			        	        $(win.document.body).find('th, td').css('border', '1px solid black');
 			        	        $(win.document.body).find('title').css('font-size', '1px');
 			        	    }
  			         }
    			      
    			       
    			    ]
    			 } );
    		
		
	},error:function(data,status,er) {$('#laoding').hide();  alert("please click again");}});
}

function showSalesEngineerPerfBooking(salesCode,smName,smPage) {
	var BookingActuals=0;
	var BillingActuals=0;
	var BookingTarget=0;
	var BillingTarget0;
	$('#laoding').show(); 
	var smCodeName,smCode;
	var currWeek = ${currWeek};
	if(smPage == "1"){
		smCodeName = smName;
		smCode = salesCode; 
		console.log(smCode);
		var exTtl = 'Salesman Performance - '+smName;
		var ttl = 'Salesman Performance '+smName;
	}else{
	 smCodeName = $("#scode option:selected").text(); 
	 smCode = $("#scode option:selected").val(); 
	 var exTtl = 'Salesman Performance - '+smName+' - ('+salesCode+')';
	 var fileName = 'Salesman Performance '+smName+' - ('+salesCode+')';
	 var subTtl = 'Current week - '+${currWeek}  + ' and Year - '+${CURR_YR};
	 var printttl = 'Salesman Performance '+smCodeName +'<br/>  Week - '+${currWeek} + ' and Year - '+${CURR_YR} +'<br/>';
	 var ttl = 'Sales Manager Performance '+smCodeName +' and Current week - '+${currWeek}  + ' and Year - '+${CURR_YR};
	}

	
	 $("#salesman_performance_modal .modal-title").html(smName);  
	 $("#salesman_performance_modal .modal-subtitle").html(subTtl);
	
	$("#salesman_performance_modal .modal-title").html(exTtl);

	$.ajax({ 
	type: 'POST',
	url: 'salesManagerPerf',  
 	data :{
 			fjtco:"se_perf" ,
 			c1 : salesCode
 			},
	dataType: "json",
	 
	success : function(data){
		$('#laoding').hide();
		var outrecv = 0, bookingTarget = 0, bookingActual = 0, gpTarget = 0, gpActual = 0,  billingTarget = 0, billingActual = 0, prcntgeBilling = 0, stage2JIH = 0, stage3LOI = 0, stage4LPO = 0, stage5LOI = 0, weekBkTarget = 0, prcntgeBooking = 0,  prcntgeBilling = 0 , prcntgeGp = 0;
		var ytdTargetBkng = 0, ytdTargetBlng = 0 , ytdTargetGp = 0 , ytdPrcntgeBkng = 0, ytdPrcntgeBlng = 0, ytdPrcntgeGp = 0, weekBlngTarget,  stage1TENDER = 0, stage3LOI = 0, actualweeklyBilling = 0 , actualweeklyBooking = 0, totalstage3and4 = 0 , stage3and4vsyearlybillingtarget = 0,converratio=0;
		var aging30 = 0, aging3060 = 0 , aging6090 = 0, aging90120 = 0,aging120180 = 0,aging181 = 0, aging90 = 0 , aging120 = 0;
		var ytdVistactuals = 0,ytdVisttarget = 0, totJIHLostVal = 0 ,JIHLostNoRepse = 0,ytdCustVistit = 0,avgweeklyorders=0;	
		
		for(var i in data){				
		switch ($.trim(data[i].srNo)) {
		  case "1.0": // total billing target
			  billingTarget = data[i].yrTot;
		    break; 
		  case "1.1": // billing gp target
			  gpTarget = data[i].yrTot;
		  case "1.2": // weekly billing target
			  weekBlngTarget = data[i].yrTot;
		    break; 
		  case "1.3": // actual weekly Billing
			  actualweeklyBilling = data[i].yrTot;
		    break; 
		  case "1.4": // YTD Billing target
			  ytdTargetBlng = data[i].yrTot;
		    break; 
		  case "1.5": // YTD Billing GP target
			  ytdTargetGp = data[i].yrTot;
		    break; 
		  case "2.0":// Total Booking Target
			  bookingTarget = data[i].yrTot;
		    break; 
		  case "2.1": // Weekly Booking Target
			  weekBkTarget = data[i].yrTot;
		    break; 
		  case "2.2": // actual weekly booking
			  actualweeklyBooking = data[i].yrTot;
		    break; 
		  case "2.3": // YTD Booking Target
			  ytdTargetBkng = data[i].yrTot;
		    break; 
		  case "3": // STAGE 1(Tender)
			  stage1TENDER = data[i].yrTot;
		    break;
		  case "3.1": // STAGE 2(JIH)
			  stage2JIH = data[i].yrTot;
		    break;
		  case "4": // STAGE3 (LOI)
			 // stage3LOI = data[i].yrTot;
			  bookingActual = data[i].yrTot;
		    break;
		  case "4.1": // YTD Booking Perc
			  ytdPrcntgeBkng = data[i].yrTot; 		 
		    break;
		  case "5": // STAGE3 (LOI)
			  stage3LOI = data[i].yrTot;
		    break;
		  case "5.1": // Stage 4 (LPO)
			  stage4LPO = data[i].yrTot;
		    break;
		  case "5.2": // total stage 3 & 4
			  totalstage3and4 = data[i].yrTot;
		    break;
		  case "5.3": // Stage 3 & 4 vs yearly billing target
			  stage3and4vsyearlybillingtarget = data[i].yrTot;
		    break;
		  case "5.4": //average weekly orders(s4)
			  avgweeklyorders = data[i].yrTot;
		    break;
		  case "6": // stage 5 ytd
			  stage5LOI = data[i].yrTot;
			  billingActual = data[i].yrTot;
		    break;
		  case "6.1": 
			  gpActual = data[i].yrTot;
		    break; 
		  case "6.2":
			  ytdPrcntgeBlng = data[i].yrTot;
		    break; 
		  case "7": 
			  outrecv = data[i].yrTot;
	       break; 
		  case "8": // Conversion Ratio
			  converratio = data[i].yrTot;
		  break;
		  case "9": // Conversion Ratio
			  ytdVistactuals = data[i].yrTot;
		  break;
		  case "9.1": // Conversion Ratio
			  ytdVisttarget = data[i].yrTot;
		  break;
		  case "10": // total JIH LOST VALUE
			  totJIHLostVal = data[i].yrTot;
		  break;
		  case "10.1": // total JIH LOST VALUE with no reason
			  JIHLostNoRepse = data[i].yrTot;
		  break;
		  case "222": 	
			  aging30 = +data[i].aging_1;			  
			  aging3060 = +data[i].aging_2; 
			  aging6090 = +data[i].aging_3;			  
			  aging90120 = +data[i].aging_4;
			  aging120180 = +data[i].aging_5;
			  aging181 = +data[i].aging_6; 
			  aging90 = aging30 + aging3060 + aging6090;
			  aging120 =  aging120180 + aging181;
		  break;
		  default:
			     break;
		}
	} 

		document.getElementById('StageGraph2').innerHTML = extractValue(stage2JIH);
        document.getElementById('StageGraph3').innerHTML = extractValue(stage3LOI);
      
		document.getElementById('StageGraph4').innerHTML = extractValue(stage4LPO);
        document.getElementById('StageGraph2').innerHTML = extractValue(stage5LOI);

		
   		 document.getElementById('Stage2').innerHTML = extractValue(stage2JIH);
         document.getElementById('Stage3').innerHTML = extractValue(stage3LOI);       
		 document.getElementById('Stage4').innerHTML = extractValue(stage4LPO);
         document.getElementById('Stage5').innerHTML = extractValue(stage5LOI);


		 document.getElementById('bookingTargetValue').innerHTML = formatNumber(ytdTargetBkng);
         document.getElementById('bookingActualValue').innerHTML = formatNumber(bookingActual);
         document.getElementById('billingTargetValue').innerHTML = formatNumber(ytdTargetBlng);
         document.getElementById('billingActualValue').innerHTML = formatNumber(billingActual);

		 drawGuageGraph(bookingActual, ytdTargetBkng, 'guage_test_booking', 'Booking');
       drawGuageGraph(billingActual, ytdTargetBlng, 'guage_test_billing', 'Billing');
		prcntgeBooking = percentageCal(bookingActual, bookingTarget);
		//ytdPrcntgeBkng = percentageCal(bookingActual, ytdTargetBkng);
		prcntgeBilling = percentageCal(billingActual, billingTarget);
		ytdPrcntgeBlng = percentageCal(billingActual, ytdTargetBlng);
		ytdCustVistit = percentageCal(ytdVistactuals,(ytdVisttarget*currWeek));
		prcntgeGp = percentageCal(gpActual, gpTarget);
		ytdPrcntgeGp = percentageCal(gpActual, ytdTargetGp);
		if(ytdPrcntgeBkng >= 100){
			percentageachievedbooking = 100;
		}else{
			percentageachievedbooking = Math.round(percentageCal(ytdPrcntgeBkng,100));
		}
		if(ytdPrcntgeBlng >= 100){
			percentageachievedbilling = 100;
		}else{
			percentageachievedbilling = Math.round(percentageCal(ytdPrcntgeBlng,100));
		}
		if(ytdCustVistit >= 100){
			percentageachievedcustvisit = 100;
		}else{
			percentageachievedcustvisit = Math.round(percentageCal(ytdCustVistit,100));
		}
		if(ytdPrcntgeGp >= 100){
			percentageachievedgeGp = 100;
		}else{
			percentageachievedgeGp =  Math.round(percentageCal(ytdPrcntgeGp,100));
		}
		
		var jihpercentage = totJIHLostVal !== 0 ? (JIHLostNoRepse / totJIHLostVal) * 100 : 0;
		if (totJIHLostVal == 0 && JIHLostNoRepse == 0) {
		    jihpercentage = 0; 
		}
		if(jihpercentage <= 10){
			jihpercentageval= 10;
		}else{
			jihpercentageval=0;
		}
		var billing120actual = aging90120 + aging120180 + aging181;		
		var billingactual = (billing120actual/billingActual)*100;
		
		if(billingactual <= 5){
			billingactualtotalper= 20;
		}else{
			billingactualtotalper=0;
		}
		//const showUpdateBtn = (getSalesEngineerDetails(data[i].seCode)[0].salesman_emp_code === loggedEmp) ? true : false; 
		var output= "<table id='salesman_performance_table' style='text-align:center; margin-left: auto; margin-right: auto;width: auto;'><thead ><tr>"
    		   +"<th class='se-brr'>Performance Title</th><th>Yearly Target</th><th>YTD Target</th><th>Actual</th><th>Yearly %</th><th>YTD %</th><th>% Achieved </th><th>Weightage</th><th>Total %</th></tr></thead><tbody>";
    	output+="<tr><td style='text-align:left;'class='se-brr'>Tender</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage1TENDER))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>JIH</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage2JIH))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				// +	"<tr><td style='text-align:left;'class='se-brr'>Stage-3(LOI)</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage3LOI))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"				 
				//+	"<tr><td style='text-align:left;' class='se-brr'>STAGE-5-(BILLING) </td><td class='se-blr'></td><td style='text-align:right;'></td><td style='text-align:right;'>"+formatNumber(stage5LOI)+ "</td><td></td></tr>"
				 +  "<tr><td style='text-align:left;' class='se-brr'>Booking </td><td style='text-align:right;'>"+formatNumber(Math.round(bookingTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetBkng))+"</td><td style='text-align:right;'>"+ formatNumber(Math.round(stage3LOI)) + "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' data-toggle='modal' data-target='#modal-default1' onclick='printAllSalesEngineerBookingCodes(\""+$.trim(data[i].smCode)+"\", \"SC\")'><i class='fa fa-file-excel-o' aria-hidden='true'></a></td><td>"+formatNumber(prcntgeBooking)+ "</td><td style='text-align:right;'>"+ytdPrcntgeBkng+ "</td><td style='text-align:right;'>"+percentageachievedbooking+ "</td><td style='text-align:right;'>"+10+ "</td><td style='text-align:right;'>"+(percentageachievedbooking*10)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Booking</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(actualweeklyBooking))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Orders</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage4LPO))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Orders</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(avgweeklyorders))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Billing</td><td style='text-align:right;'>"+formatNumber(Math.round(billingTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetBlng))+"</td><td style='text-align:right;background-color:#F08080;font-weight: bold'>"+ formatNumber(Math.round(billingActual))  + "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' data-toggle='modal' data-target='#modal-default1' onclick='printAllSalesEngineerBillingCodes(\""+$.trim(data[i].smCode)+"\", \"SC\")'><i class='fa fa-file-excel-o' aria-hidden='true'></i></a></td><td>"+formatNumber(prcntgeBilling)+ "</td><td style='text-align:right;'>"+ytdPrcntgeBlng+ "</td><td style='text-align:right;'>"+percentageachievedbilling+ "</td><td style='text-align:right;'>"+5+ "</td><td style='text-align:right;'>"+(percentageachievedbilling*5)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Billing</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(actualweeklyBilling))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Customer Visit</td><td>-</td><td style='text-align:right;'>"+formatNumber(ytdVisttarget*currWeek)+ "</td><td style='text-align:right;'>"+formatNumber(ytdVistactuals)+ "</td><td>-</td><td>"+formatNumber(ytdCustVistit)+"</td><td style='text-align:right;'>"+percentageachievedcustvisit+ "</td><td style='text-align:right;'>"+5+"</td><td style='text-align:right;'>"+(percentageachievedcustvisit*5)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Total JIH Lost</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(totJIHLostVal))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;width:35%;' class='se-brr'>JIH Lost with NR</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(JIHLostNoRepse))+ "</td><td>-</td><td>-</td><td>-</td><td style='text-align:right;'>"+10+"</td><td style='text-align:right;'><a href='#' data-toggle='modal' data-target='#help-modaljihnoresp'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a>"+jihpercentageval+"</td></tr>"
				 +  "<tr><td style='text-align:left;'class='se-brr'>Gross Profit</td><td style='text-align:right;'>"+formatNumber(Math.round(gpTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetGp))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(gpActual))+ "</td><td>"+formatNumber(prcntgeGp)+ "</td><td style='text-align:right;'>"+ytdPrcntgeGp+ "</td><td style='text-align:right;'>"+percentageachievedgeGp+ "</td><td style='text-align:right;'>"+50+ "</td><td style='text-align:right;'>"+(percentageachievedgeGp*50)/100+"</td></tr>"
				// +  "<tr><td style='text-align:left;font-weight: bold;' class='se-brr'>CONVERSION RATIO  <a href='#' data-toggle='modal' data-target='#help-modal'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a></td><td class='se-blr'></td><td>-</td><td>-</td><td style='text-align:right;font-weight: bold'>"+formatNumber(converratio)+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"			
				 //+	"<tr><td style='text-align:left;' class='se-bbr'></td><td style='text-align:left;' > <90 Days </td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(aging90))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				// +	"<tr><td style='text-align:left;' class='se-bbtr'>OUTSTANDING-RECV </td><td style='text-align:left;' > >90 Days </td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(aging90120))+"</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;background-color:#F08080;font-weight: bold;' >Outstanding-Recv >120 Days </td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='text-align:right;background-color:#F08080;font-weight: bold;'>"+formatNumber(Math.round(aging120))+"</td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='text-align:right;background-color:#F08080'>"+20+"</td><td style='text-align:right;background-color:#F08080'><a href='#' data-toggle='modal' data-target='#help-modalfor120days'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a>"+billingactualtotalper+"</td></tr>"
				 +	"<tr><td style='text-align:left;font-weight: bold;' > Total %</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td><td style='text-align:right;font-weight: bold;'>"+Math.round((((percentageachievedbooking*10)/100)+((percentageachievedbilling*5)/100)+((percentageachievedcustvisit*5)/100)+((percentageachievedgeGp*50)/100)+billingactualtotalper+jihpercentageval))+"</td></tr>";
 
    			output+="</tbody></table>"; 

    			   var buttonHtmlBooking = "<div class='col-sm-6'><button type='button' class='btn btn-primary btn-block' style='width:100%' onclick='printAllSalesEngineerBookingCodes(\"" + $.trim(smCode) + "\", \"SC\")'>Booking Details</button></div>";

    	    		// Define the button HTML for billing details
    	    		//var buttonHtmlBilling = "<div class='col-sm-3'><button type='button' class='btn btn-primary btn-block' onclick='printAllSalesEngineerBillingCodes(\"" + $.trim(data[i].smCode)+"\", \"SC\")'>Billing Details</button></div>";
    	    	    var buttonHtmlBilling = "<div class='col-sm-6'><button type='button' class='btn btn-primary btn-block' style='width:100%' onclick='printAllSalesEngineerBillingCodes(\"" +$.trim(smCode) + "\", \"SC\")'>Billing Details</button></div>";


    	    		// Combine both button HTMLs within a Bootstrap row
    	    		var combinedButtonsHtml = "<div class='row'>" + buttonHtmlBooking + buttonHtmlBilling + "</div>";
    	    		// Insert the combined buttons into the container
    	    		$("#performance_container").html(combinedButtonsHtml);

    			var subTtl1 =  'Conversion Ratio - '+formatNumber(converratio) +"<a href='#' data-toggle='modal' data-target='#help-modal'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;padding-right: 670px;'></i></a>";
    		//	$("#salesman_performance_modal .modal-body").html(output);  
    		//	$("#salesman_performance_modal .modal-subtitle2").html(subTtl1);
    		//	$("#salesman_performance_modal").modal("show");
    	
    			$("#salesman_performance_table").DataTable( {
    				dom: 'Bfrtip',
    				searching: false,
    			    ordering:  false,
    			    paging: false,
    			    info: false,
    			     buttons: [
    			         {
    			            extend: 'excelHtml5',
    			             text:      '<i class="fa fa-file-excel-o" style="color: #1979a9; font-size: 1em;">Export</i>',
    			             filename: fileName,
    			             title: ttl,
    			             messageTop: 'File Processed on : ${currCal} ,The information in this file is copyright to Faisal Jassim Group.'
    			         },
    			         {
 			        	    extend: 'print', 
 			        	    text:      '<i class="fa fa-print" style="color: #1979a9; font-size: 1em;">Print</i>',  

 			        	    title: printttl + " Conversion Ratio: "+formatNumber(converratio),
 			        	    customize: (win) => {
 			        	    	$(win.document.head).append('<style>h1 { font-size: 14px; }</style>'); // Adjust the font size of the title
 			        	    	$(win.document.body)    			        	        
 	                            .css("height", "auto")
 		        	            .css("min-height", "0");
 			        	        $(win.document.body).find( 'table' )
 			                    .addClass( 'compact' )
 			                    .css( 'font-size', 'inherit' );
 			        	        $(win.document.body).find('table').css('border-collapse', 'collapse');
 			        	        $(win.document.body).find('th, td').css('border', '1px solid black');
 			        	        $(win.document.body).find('title').css('font-size', '1px');
 			        	    }
  			         }
    			      
    			       
    			    ]
    			 } );
    		
		
	},error:function(data,status,er) {$('#laoding').hide();  alert("please click again");}});
}

//sales booking perf
function sm_performance_booking(){
	var BookingActuals=0;
	var BillingActuals=0;
	var BookingTarget=0;
	var BillingTarget0;
	console.log(BookingActuals);
	$('#laoding').show(); 
	var smCodeName = $("#scode option:selected").text(); 
	var smCode = $("#scode option:selected").val(); 
	selectElement = document.querySelector('#scode');
    output = selectElement.options[selectElement.selectedIndex].value;
    salesCode = selectElement.options[selectElement.selectedIndex].role;
    var currWeek = ${currWeek};
 	if(smCode == "0"){
 		alert("Please select any Sales Manager");
 		return false;
 	}
 	
 	if(salesCode != null){
 		showSalesEngineerPerfBooking(salesCode,smCodeName,"1");
 		return;
 	}
	 $("#salesmanager_performance_modal .modal-title").html(smCodeName);  	  
	var exTtl = 'Sales Manager Performance - '+smCodeName;
	var subTtl = 'Current week - '+${currWeek}  + ' and Year - '+${CURR_YR};
	var ttl = 'Sales Manager Performance '+smCodeName +' and Current week - '+${currWeek} + ' and Year - '+${CURR_YR}; 
	var printttl = 'Sales Manager Performance '+smCodeName +'<br/>  Week - '+${currWeek} + ' and Year - '+${CURR_YR} +'<br/>';
	var fileName = 'Sales Manager Performance '+smCodeName;
	$("#salesmanager_performance_modal .modal-title").html(exTtl);
	$("#salesmanager_performance_modal .modal-subtitle").html(subTtl);
	$.ajax({ 
	type: 'POST',
	url: 'salesManagerPerf',  
 	data :{
 			fjtco:"sm_perf" ,
 			c1 : smCode
 			},
	dataType: "json",
	 
	success : function(data){
	//	alert(data);
		$('#laoding').hide();
		var outrecv = 0, bookingTarget = 0, bookingActual = 0, gpTarget = 0, gpActual = 0,  billingTarget = 0, billingActual = 0, prcntgeBilling = 0, stage2JIH = 0, stage3LOI = 0, stage4LPO = 0, stage5LOI = 0, weekBkTarget = 0, prcntgeBooking = 0,  prcntgeBilling = 0 , prcntgeGp = 0;
		var ytdTargetBkng = 0, ytdTargetBlng = 0 , ytdTargetGp = 0 , ytdPrcntgeBkng = 0, ytdPrcntgeBlng = 0, ytdPrcntgeGp = 0, weekBlngTarget,  stage1TENDER = 0, stage3LOI = 0, actualweeklyBilling = 0 , actualweeklyBooking = 0, totalstage3and4 = 0 , stage3and4vsyearlybillingtarget = 0,converratio=0;
		var smName=""; var list = [],agingbelow90 = 0 , agingabove90 = 0, agingabove120 = 0,avgweeklyorders=0,ytdVisttarget = 0;
		for(var i in data){		
		
		switch ($.trim(data[i].srNo)) {
		  case "1.0": // total billing target			 
			  billingTarget = data[i].yrTot;
			   break; 
		  case "1.1": // billing gp target
			  gpTarget = data[i].yrTot;
		  case "1.2": // weekly billing target
			  weekBlngTarget = data[i].yrTot;
		    break; 
		  case "1.3": // actual weekly Billing
			  actualweeklyBilling = data[i].yrTot;
		    break; 
		  case "1.4": // YTD Billing target
			  ytdTargetBlng = data[i].yrTot;
		    break; 
		  case "1.5": // YTD Billing GP target
			  ytdTargetGp = data[i].yrTot;
		    break; 
		  case "2.0":// Total Booking Target
			  bookingTarget = data[i].yrTot;			 
		    break; 
		  case "2.1": // Weekly Booking Target
			  weekBkTarget = data[i].yrTot;
		    break; 
		  case "2.2": // actual weekly booking
			  actualweeklyBooking = data[i].yrTot;
		    break; 
		  case "2.3": // YTD Booking Target
			  ytdTargetBkng = data[i].yrTot;
		    break; 
		  case "3": // STAGE 1(Tender)
			  stage1TENDER = data[i].yrTot;
		    break;
		  case "3.1": // STAGE 2(JIH)
			  stage2JIH = data[i].yrTot;
		    break;
		  case "4": // STAGE3 (LOI)
			//  stage3LOI = data[i].yrTot;
			  bookingActual = data[i].yrTot;			 
		    break;
		/*  case "4.1": // YTD Booking Perc
			  ytdPrcntgeBkng = data[i].yrTot; 
		    break;*/
		  case "5": // STAGE3 (LOI)
			  stage3LOI = data[i].yrTot;
		    break;
		  case "5.1": // Stage 4 (LPO)
			  stage4LPO = data[i].yrTot;
		    break;
		  case "5.2": // total stage 3 & 4
			  totalstage3and4 = data[i].yrTot;
		    break;
		  case "5.3": // Stage 3 & 4 vs yearly billing target
			  stage3and4vsyearlybillingtarget = data[i].yrTot;
		    break;
		  case "5.4": //average weekly orders(s4)
			  avgweeklyorders = data[i].yrTot;
		    break;
		  case "6": // stage 5 ytd
			  stage5LOI = data[i].yrTot;
			  billingActual = data[i].yrTot;
		    break;
		  case "6.1": 
			  gpActual = data[i].yrTot;
		    break; 
		 /* case "6.2":
			  ytdPrcntgeBlng = data[i].yrTot;
		    break; */
		  case "7": 
			  outrecv = data[i].yrTot;
			  break;
		  case "7.1": 
			  agingbelow90 = data[i].yrTot;
			  break;
		  case "7.2": 
			  agingabove90 = data[i].yrTot;
			  break;
		  case "7.3": 
			  agingabove120 = data[i].yrTot;
			  break;
	       break; 
		  case "8": // Conversion Ratio
			  converratio = data[i].yrTot;
		  break;
		  case "9": // customer visit actuals
			  ytdVistactuals = data[i].yrTot;			 
		  break;
		  case "9.1": // customer visit weekly target
			  ytdVisttarget = data[i].yrTot;
		  break;
		  case "10": // total JIH LOST VALUE
			  totJIHLostVal = data[i].yrTot;
		  break;
		  case "10.1": // total JIH LOST VALUE with no reason
			  JIHLostNoRepse = data[i].yrTot;
		  break;
		  case "11": 			
			  var footerout="";			 
			  for (var key in data[i].salesEnglist) {				  
				     footerout += "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal-default1' onclick='showSalesEngineerPerf(\""+key+"\", \""+data[i].salesEnglist[key]+"\")'>"+data[i].salesEnglist[key]+"</a>";			     	
				   }
		  break;

		 
		  default:				 
			     break;
		}
	} 
		document.getElementById('StageGraph2').innerHTML = extractValue(stage2JIH);
        document.getElementById('StageGraph3').innerHTML = extractValue(stage3LOI);
      
		document.getElementById('StageGraph4').innerHTML = extractValue(stage4LPO);
        document.getElementById('StageGraph2').innerHTML = extractValue(stage5LOI);

		
		document.getElementById('Stage2').innerHTML = extractValue(stage2JIH);
        document.getElementById('Stage3').innerHTML = extractValue(stage3LOI);
	    document.getElementById('Stage4').innerHTML = extractValue(stage4LPO);
        document.getElementById('Stage5').innerHTML = extractValue(stage5LOI);

	    document.getElementById('bookingTargetValue').innerHTML = formatNumber(ytdTargetBkng);
        document.getElementById('bookingActualValue').innerHTML = formatNumber(bookingActual);
        document.getElementById('billingTargetValue').innerHTML = formatNumber(ytdTargetBlng);
        document.getElementById('billingActualValue').innerHTML = formatNumber(billingActual);

		drawGuageGraph(bookingActual, ytdTargetBkng, 'guage_test_booking', 'Booking');
        drawGuageGraph(billingActual, ytdTargetBlng, 'guage_test_billing', 'Billing');

		prcntgeBooking = percentageCal(bookingActual, bookingTarget);
		ytdPrcntgeBkng = percentageCal(bookingActual, ytdTargetBkng);
		prcntgeBilling = percentageCal(billingActual, billingTarget);
		ytdPrcntgeBlng = percentageCal(billingActual, ytdTargetBlng);
		prcntgeGp = percentageCal(gpActual, gpTarget);
		ytdPrcntgeGp = percentageCal(gpActual, ytdTargetGp);
		
		ytdCustVistit = percentageCal(ytdVistactuals,(ytdVisttarget*currWeek));
		if(ytdPrcntgeBkng >= 100){
			percentageachievedbooking = 100;
		}else{
			percentageachievedbooking = Math.round(percentageCal(ytdPrcntgeBkng,100));
		}
		if(ytdPrcntgeBlng >= 100){
			percentageachievedbilling = 100;
		}else{
			percentageachievedbilling = Math.round(percentageCal(ytdPrcntgeBlng,100));
		}
		if(ytdPrcntgeGp >= 100){
			percentageachievedgeGp = 100;
		}else{
			percentageachievedgeGp =  Math.round(percentageCal(ytdPrcntgeGp,100));
		}
		var billing120actual = ${aging90120 + aging120180 + aging181};
		var billingactual = (billing120actual/billingActual)*100;
		if(billingactual <= 5){
			billingactualtotalper= 20;
		}else{
			billingactualtotalper=0;
		}
		var jihpercentage = totJIHLostVal !== 0 ? (JIHLostNoRepse / totJIHLostVal) * 100 : 0;
		if (totJIHLostVal == 0 && JIHLostNoRepse == 0) {
		    jihpercentage = 0; 
		}
		if(jihpercentage <= 10){
			jihpercentageval= 10;
		}else{
			jihpercentageval=0;
		}if(ytdCustVistit >= 100){
			percentageachievedcustvisit = 100;
		}else{
			percentageachievedcustvisit = Math.round(percentageCal(ytdCustVistit,100));
		}
		var output= "<table id='salesmanager_performance_table' style='text-align:center; margin-left: auto; margin-right: auto;width: auto;'><thead ><tr>"
			     +"<th class='se-brr'>Performance Title</th><th>Yearly Target</th><th>YTD Target</th><th>Actual</th><th>Yearly %</th><th>YTD %</th><th>% Achieved </th><th>Weightage</th><th>Total %</th></tr></thead><tbody>";
    	output+= "<tr><td style='text-align:left;'class='se-brr'>Tender</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage1TENDER))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>JIH</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage2JIH))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				// +	"<tr><td style='text-align:left;'class='se-brr'>Stage-3(LOI)</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage3LOI))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 //+	"<tr><td style='text-align:left;' class='se-brr'>STAGE-4-(LPO) </td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage4LPO))+ "</td><td>-</td><td>-</td></tr>"
				//+	"<tr><td style='text-align:left;' class='se-brr'>STAGE-5-(BILLING) </td><td class='se-blr'></td><td style='text-align:right;'></td><td style='text-align:right;'>"+formatNumber(stage5LOI)+ "</td><td></td></tr>"
				 //+  "<tr><td style='text-align:left;' class='se-brr'>Booking sdf</td><td style='text-align:right;'>"+formatNumber(Math.round(bookingTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetBkng))+"</td><td style='text-align:right;'>"+ formatNumber(Math.round(bookingActual)) + "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal-default1' onclick='printAllSalesEngineerCodes(\""+smCode+"\")'>Show All</a></td><td>"+formatNumber(prcntgeBooking)+ "</td><td style='text-align:right;'>"+ytdPrcntgeBkng+ "</td><td style='text-align:right;'>"+percentageachievedbooking+ "</td><td style='text-align:right;'>"+10+ "</td><td style='text-align:right;'>"+(percentageachievedbooking*10)/100+"</td></tr>"
				  +  "<tr><td style='text-align:left;' class='se-brr'>Booking</td><td style='text-align:right;'>"+formatNumber(Math.round(bookingTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetBkng))+"</td><td style='text-align:right;'>"+ formatNumber(Math.round(bookingActual)) + "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal-default1' onclick='printAllSalesEngineerBookingCodes(\""+$.trim(data[i].smCode)+"\", \"SC\")'>Show All</a></td><td>"+formatNumber(prcntgeBooking)+ "</td><td style='text-align:right;'>"+ytdPrcntgeBkng+ "</td><td style='text-align:right;'>"+percentageachievedbooking+ "</td><td style='text-align:right;'>"+5+ "</td><td style='text-align:right;'>"+(percentageachievedbooking*5)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Booking</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(actualweeklyBooking))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Orders</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage4LPO))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Orders</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(avgweeklyorders))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Billing</td><td style='text-align:right;'>"+formatNumber(Math.round(billingTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetBlng))+"</td><td style='text-align:right;'>"+ formatNumber(Math.round(billingActual)) + "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal-default1' onclick='printAllSalesEngineerBillingCodes(\""+smCode+"\")'>Show All</a></td><td>"+formatNumber(prcntgeBilling)+ "</td><td style='text-align:right;'>"+ytdPrcntgeBlng+ "</td><td style='text-align:right;'>"+percentageachievedbilling+ "</td><td style='text-align:right;'>"+5+ "</td><td style='text-align:right;'>"+(percentageachievedbilling*5)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Billing</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(actualweeklyBilling))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Customer Visit</td><td>-</td><td style='text-align:right;'>"+formatNumber(ytdVisttarget*currWeek)+ "</td><td style='text-align:right;'>"+formatNumber(ytdVistactuals)+ "</td><td>-</td><td>"+formatNumber(ytdCustVistit)+"</td><td style='text-align:right;'>"+percentageachievedcustvisit+ "</td><td style='text-align:right;'>"+5+"</td><td style='text-align:right;'>"+(percentageachievedcustvisit*5)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Total JIH Lost</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(totJIHLostVal))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;width:35%;' class='se-brr'>JIH Lost with NR</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(JIHLostNoRepse))+ "</td><td>-</td><td>-</td><td>-</td><td style='text-align:right;'>"+10+"</td><td style='text-align:right;'><a href='#' data-toggle='modal' data-target='#help-modaljihnoresp'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a>"+jihpercentageval+"</td></tr>"
				 +	"<tr><td style='text-align:left;'class='se-brr'>Gross Profit</td><td style='text-align:right;'>"+formatNumber(Math.round(gpTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetGp))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(gpActual))+ "</td><td>"+formatNumber(prcntgeGp)+ "</td><td style='text-align:right;'>"+ytdPrcntgeGp+ "</td><td style='text-align:right;'>"+percentageachievedgeGp+ "</td><td style='text-align:right;'>"+50+ "</td><td style='text-align:right;'>"+(percentageachievedgeGp*50)/100+"</td></tr>"
				// +  "<tr><td style='text-align:left;font-weight: bold;' class='se-brr'>CONVERSION RATIO  <a href='#' data-toggle='modal' data-target='#help-modal'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a></td><td class='se-blr'></td><td>-</td><td>-</td><td style='text-align:right;font-weight: bold'>"+formatNumber(converratio)+ "</td><td>-</td><td>-</td></tr>"
				// +	"<tr><td style='text-align:left;' class='se-bbr'></td><td style='text-align:left;' > <90 Days </td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(agingbelow90))+"</td><td>-</td><td>-</td></tr>"
				// +	"<tr><td style='text-align:left;' class='se-bbtr'>OUTSTANDING-RECV </td><td style='text-align:left;font-weight: bold;background-color:#F08080;' > >90 Days </td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080;'>-</td><td style='text-align:right;font-weight: bold;background-color:#F08080'>"+formatNumber(agingabove90)+"</td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td></tr>"
				 +	"<tr><td style='text-align:left;background-color:#F08080;font-weight: bold;' >Outstanding-Recv >120 Days </td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='text-align:right;background-color:#F08080;font-weight: bold;'>"+formatNumber(Math.round(agingabove120))+"</td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='text-align:right;background-color:#F08080'>"+20+"</td><td style='text-align:right;background-color:#F08080'><a href='#' data-toggle='modal' data-target='#help-modalfor120days'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a>"+billingactualtotalper+"</td></tr>"
				// +	"<tr><td class='se-btr'></td><td style='text-align:left;' > Total </td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(outrecv)+ "</td><td>-</td><td>-</td></tr>";
 
    			output+="</tbody></table>"; 
    			var subTtl1 =  'Conversion Ratio - '+formatNumber(converratio) +"<a href='#' data-toggle='modal' data-target='#help-modal'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;padding-right: 70%;'></i></a><button type='button' class='btn btn-default' data-dismiss='modal'>Close</button>";
    			/* $("#salesmanager_performance_modal .modal-body").html(output);  
    			$("#salesmanager_performance_modal .modal-subtitle3").html(subTtl1);
    			$("#salesmanager_performance_modal .modal-footer").html(footerout);  
    			$("#salesmanager_performance_modal").modal("show");
    			
 */
				  // Jquery draggable
				/*   $('.modal-dialog').draggable({
				      handle: ".modal-header"
				  });
    	 */
    	    var buttonHtmlBooking = "<div class='col-sm-6'><button type='button' class='btn btn-primary btn-block' style='width:100%' onclick='printAllSalesEngineerBookingCodes(\"" + $.trim(smCode) + "\", \"SC\")'>Booking Details</button></div>";

    		// Define the button HTML for billing details
    		//var buttonHtmlBilling = "<div class='col-sm-3'><button type='button' class='btn btn-primary btn-block' onclick='printAllSalesEngineerBillingCodes(\"" + $.trim(data[i].smCode)+"\", \"SC\")'>Billing Details</button></div>";
    	    var buttonHtmlBilling = "<div class='col-sm-6'><button type='button' class='btn btn-primary btn-block' style='width:100%' onclick='printAllSalesEngineerBillingCodes(\"" + smCode + "\")'>Billing Details</button></div>";

    		// Combine both button HTMLs within a Bootstrap row
    		var combinedButtonsHtml = "<div class='row'>" + buttonHtmlBooking + buttonHtmlBilling + "</div>";

    		// Insert the combined buttons into the container
    		$("#performance_container").html(combinedButtonsHtml);

    			$("#salesmanager_performance_tables").DataTable( {
    				dom: 'Bfrtip',
    				searching: false,
    			    ordering:  false,
    			    paging: false,
    			    info: false,
    			     buttons: [
    			         {
    			            extend: 'excelHtml5',
    			             text:      '<i class="fa fa-file-excel-o" style="color: #1979a9; font-size: 1em;">Export</i>',
    			             filename: fileName,
    			             title: ttl,
    			             messageTop: 'File Processed on : ${currCal} ,The information in this file is copyright to Faisal Jassim Group.'
    			            
    			            
    			         },
    			         {
 			        	    extend: 'print', 
 			        	    text:      '<i class="fa fa-print" style="color: #1979a9; font-size: 1em;">Print</i>',    			        	  
 			        	    title: printttl + " Conversion Ratio: "+formatNumber(converratio),
			        	    customize: (win) => {
			        	    	$(win.document.head).append('<style>h1 { font-size: 14px; }</style>'); // Adjust the font size of the title
			        	    	$(win.document.body)    			        	        
	                            .css("height", "auto")
		        	            .css("min-height", "0");
			        	        $(win.document.body).find( 'table' )
			                    .addClass( 'compact' )
			                    .css( 'font-size', 'inherit' );
			        	        $(win.document.body).find('table').css('border-collapse', 'collapse');
			        	        $(win.document.body).find('th, td').css('border', '1px solid black');
			        	        $(win.document.body).find('title').css('font-size', '1px');
			        	    }
 			         }
    			    ]
    			 } );
		
	},error:function(data,status,er) {$('#laoding').hide();  alert("please click again");}});
}


//sales performance summary
function sm_performance_details(){
	$('#laoding').show(); 
	var smCodeName = $("#scode option:selected").text(); 
	var smCode = $("#scode option:selected").val(); 
	selectElement = document.querySelector('#scode');
    output = selectElement.options[selectElement.selectedIndex].value;
    salesCode = selectElement.options[selectElement.selectedIndex].role;
    var currWeek = ${currWeek};
 	if(smCode == "0"){
 		alert("Please select any Sales Manager");
 		return false;
 	}
 	
 	if(salesCode != null){
 		showSalesEngineerPerf(salesCode,smCodeName,"1");
 		return;
 	}
	 $("#salesmanager_performance_modal .modal-title").html(smCodeName);  	  
	var exTtl = 'Sales Manager Performance - '+smCodeName;
	var subTtl = 'Current week - '+${currWeek}  + ' and Year - '+${CURR_YR};
	var ttl = 'Sales Manager Performance '+smCodeName +' and Current week - '+${currWeek} + ' and Year - '+${CURR_YR}; 
	var printttl = 'Sales Manager Performance '+smCodeName +'<br/>  Week - '+${currWeek} + ' and Year - '+${CURR_YR} +'<br/>';
	var fileName = 'Sales Manager Performance '+smCodeName;
	$("#salesmanager_performance_modal .modal-title").html(exTtl);
	$("#salesmanager_performance_modal .modal-subtitle").html(subTtl);
	$.ajax({ 
	type: 'POST',
	url: 'salesManagerPerf',  
 	data :{
 			fjtco:"sm_perf" ,
 			c1 : smCode
 			},
	dataType: "json",
	 
	success : function(data){
		$('#laoding').hide();
		var outrecv = 0, bookingTarget = 0, bookingActual = 0, gpTarget = 0, gpActual = 0,  billingTarget = 0, billingActual = 0, prcntgeBilling = 0, stage2JIH = 0, stage3LOI = 0, stage4LPO = 0, stage5LOI = 0, weekBkTarget = 0, prcntgeBooking = 0,  prcntgeBilling = 0 , prcntgeGp = 0;
		var ytdTargetBkng = 0, ytdTargetBlng = 0 , ytdTargetGp = 0 , ytdPrcntgeBkng = 0, ytdPrcntgeBlng = 0, ytdPrcntgeGp = 0, weekBlngTarget,  stage1TENDER = 0, stage3LOI = 0, actualweeklyBilling = 0 , actualweeklyBooking = 0, totalstage3and4 = 0 , stage3and4vsyearlybillingtarget = 0,converratio=0;
		var smName=""; var list = [],agingbelow90 = 0 , agingabove90 = 0, agingabove120 = 0,avgweeklyorders=0,ytdVisttarget = 0;
		for(var i in data){		
		
		switch ($.trim(data[i].srNo)) {
		  case "1.0": // total billing target			 
			  billingTarget = data[i].yrTot;
		    break; 
		  case "1.1": // billing gp target
			  gpTarget = data[i].yrTot;
		  case "1.2": // weekly billing target
			  weekBlngTarget = data[i].yrTot;
		    break; 
		  case "1.3": // actual weekly Billing
			  actualweeklyBilling = data[i].yrTot;
		    break; 
		  case "1.4": // YTD Billing target
			  ytdTargetBlng = data[i].yrTot;
		    break; 
		  case "1.5": // YTD Billing GP target
			  ytdTargetGp = data[i].yrTot;
		    break; 
		  case "2.0":// Total Booking Target
			  bookingTarget = data[i].yrTot;
		    break; 
		  case "2.1": // Weekly Booking Target
			  weekBkTarget = data[i].yrTot;
		    break; 
		  case "2.2": // actual weekly booking
			  actualweeklyBooking = data[i].yrTot;
		    break; 
		  case "2.3": // YTD Booking Target
			  ytdTargetBkng = data[i].yrTot;
		    break; 
		  case "3": // STAGE 1(Tender)
			  stage1TENDER = data[i].yrTot;
		    break;
		  case "3.1": // STAGE 2(JIH)
			  stage2JIH = data[i].yrTot;
		    break;
		  case "4": // STAGE3 (LOI)
			 // stage3LOI = data[i].yrTot;
			  bookingActual = data[i].yrTot;
		    break;
		/*  case "4.1": // YTD Booking Perc
			  ytdPrcntgeBkng = data[i].yrTot; 
		    break;*/
		  case "5": // STAGE3 (LOI)
			  stage3LOI = data[i].yrTot;
		    break;
		  case "5.1": // Stage 4 (LPO)
			  stage4LPO = data[i].yrTot;
		    break;
		  case "5.2": // total stage 3 & 4
			  totalstage3and4 = data[i].yrTot;
		    break;
		  case "5.3": // Stage 3 & 4 vs yearly billing target
			  stage3and4vsyearlybillingtarget = data[i].yrTot;
		    break;
		  case "5.4": //average weekly orders(s4)
			  avgweeklyorders = data[i].yrTot;
		    break;
		  case "6": // stage 5 ytd
			  stage5LOI = data[i].yrTot;
			  billingActual = data[i].yrTot;
		    break;
		  case "6.1": 
			  gpActual = data[i].yrTot;
		    break; 
		 /* case "6.2":
			  ytdPrcntgeBlng = data[i].yrTot;
		    break; */
		  case "7": 
			  outrecv = data[i].yrTot;
			  break;
		  case "7.1": 
			  agingbelow90 = data[i].yrTot;
			  break;
		  case "7.2": 
			  agingabove90 = data[i].yrTot;
			  break;
		  case "7.3": 
			  agingabove120 = data[i].yrTot;
			  break;
	       break; 
		  case "8": // Conversion Ratio
			  converratio = data[i].yrTot;
		  break;
		  case "9": // customer visit actuals
			  ytdVistactuals = data[i].yrTot;			 
		  break;
		  case "9.1": // customer visit weekly target
			  ytdVisttarget = data[i].yrTot;
		  break;
		  case "10": // total JIH LOST VALUE
			  totJIHLostVal = data[i].yrTot;
		  break;
		  case "10.1": // total JIH LOST VALUE with no reason
			  JIHLostNoRepse = data[i].yrTot;
		  break;
		  case "11": 			
			  var footerout="";			 
			  for (var key in data[i].salesEnglist) {				  
				     footerout += "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal-default1' onclick='showSalesEngineerPerf(\""+key+"\", \""+data[i].salesEnglist[key]+"\")'>"+data[i].salesEnglist[key]+"</a>";			     	
				   }
		  break;

		 
		  default:				 
			     break;
		}
	} 
		
		prcntgeBooking = percentageCal(bookingActual, bookingTarget);
		ytdPrcntgeBkng = percentageCal(bookingActual, ytdTargetBkng);
		prcntgeBilling = percentageCal(billingActual, billingTarget);
		ytdPrcntgeBlng = percentageCal(billingActual, ytdTargetBlng);
		prcntgeGp = percentageCal(gpActual, gpTarget);
		ytdPrcntgeGp = percentageCal(gpActual, ytdTargetGp);
		
		ytdCustVistit = percentageCal(ytdVistactuals,(ytdVisttarget*currWeek));
		if(ytdPrcntgeBkng >= 100){
			percentageachievedbooking = 100;
		}else{
			percentageachievedbooking = Math.round(percentageCal(ytdPrcntgeBkng,100));
		}
		if(ytdPrcntgeBlng >= 100){
			percentageachievedbilling = 100;
		}else{
			percentageachievedbilling = Math.round(percentageCal(ytdPrcntgeBlng,100));
		}
		if(ytdPrcntgeGp >= 100){
			percentageachievedgeGp = 100;
		}else{
			percentageachievedgeGp =  Math.round(percentageCal(ytdPrcntgeGp,100));
		}
		var billing120actual = ${aging90120 + aging120180 + aging181};
		var billingactual = (billing120actual/billingActual)*100;
		if(billingactual <= 5){
			billingactualtotalper= 20;
		}else{
			billingactualtotalper=0;
		}
		var jihpercentage = totJIHLostVal !== 0 ? (JIHLostNoRepse / totJIHLostVal) * 100 : 0;
		if (totJIHLostVal == 0 && JIHLostNoRepse == 0) {
		    jihpercentage = 0; 
		}
		if(jihpercentage <= 10){
			jihpercentageval= 10;
		}else{
			jihpercentageval=0;
		}if(ytdCustVistit >= 100){
			percentageachievedcustvisit = 100;
		}else{
			percentageachievedcustvisit = Math.round(percentageCal(ytdCustVistit,100));
		}
		var output= "<table id='salesmanager_performance_table' style='text-align:center; margin-left: auto; margin-right: auto;width: auto;'><thead ><tr>"
			     +"<th class='se-brr'>Performance Title</th><th>Yearly Target</th><th>YTD Target</th><th>Actual</th><th>Yearly %</th><th>YTD %</th><th>% Achieved </th><th>Weightage</th><th>Total %</th></tr></thead><tbody>";
    	output+= "<tr><td style='text-align:left;'class='se-brr'>Tender</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage1TENDER))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>JIH</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage2JIH))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				// +	"<tr><td style='text-align:left;'class='se-brr'>Stage-3(LOI)</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage3LOI))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 //+	"<tr><td style='text-align:left;' class='se-brr'>STAGE-4-(LPO) </td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage4LPO))+ "</td><td>-</td><td>-</td></tr>"
				//+	"<tr><td style='text-align:left;' class='se-brr'>STAGE-5-(BILLING) </td><td class='se-blr'></td><td style='text-align:right;'></td><td style='text-align:right;'>"+formatNumber(stage5LOI)+ "</td><td></td></tr>"
				 //+  "<tr><td style='text-align:left;' class='se-brr'>Booking sdf</td><td style='text-align:right;'>"+formatNumber(Math.round(bookingTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetBkng))+"</td><td style='text-align:right;'>"+ formatNumber(Math.round(bookingActual)) + "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' class='btn btn-primary btn-xs' data-toggle='modal' data-target='#modal-default1' onclick='printAllSalesEngineerCodes(\""+smCode+"\")'>Show All</a></td><td>"+formatNumber(prcntgeBooking)+ "</td><td style='text-align:right;'>"+ytdPrcntgeBkng+ "</td><td style='text-align:right;'>"+percentageachievedbooking+ "</td><td style='text-align:right;'>"+10+ "</td><td style='text-align:right;'>"+(percentageachievedbooking*10)/100+"</td></tr>"
				  +  "<tr><td style='text-align:left;' class='se-brr'>Booking</td><td style='text-align:right;'>"+formatNumber(Math.round(bookingTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetBkng))+"</td><td style='text-align:right;'>"+ formatNumber(Math.round(bookingActual)) + "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' data-toggle='modal' data-target='#modal-default1' onclick='printAllSalesEngineerBookingCodes(\""+$.trim(data[i].smCode)+"\", \"SC\")'><i class='fa fa-file-excel-o' aria-hidden='true'></a></td><td>"+formatNumber(prcntgeBooking)+ "</td><td style='text-align:right;'>"+ytdPrcntgeBkng+ "</td><td style='text-align:right;'>"+percentageachievedbooking+ "</td><td style='text-align:right;'>"+5+ "</td><td style='text-align:right;'>"+(percentageachievedbooking*5)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Booking</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(actualweeklyBooking))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Orders</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(stage4LPO))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Orders</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(avgweeklyorders))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Billing</td><td style='text-align:right;'>"+formatNumber(Math.round(billingTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetBlng))+"</td><td style='text-align:right;'>"+ formatNumber(Math.round(billingActual)) + "<a href ='#' data-backdrop='static' style='text-align: left' data-keyboard='false' data-toggle='modal' data-target='#modal-default1' onclick='printAllSalesEngineerBillingCodes(\""+smCode+"\")'><i class='fa fa-file-excel-o' aria-hidden='true'></a></td><td>"+formatNumber(prcntgeBilling)+ "</td><td style='text-align:right;'>"+ytdPrcntgeBlng+ "</td><td style='text-align:right;'>"+percentageachievedbilling+ "</td><td style='text-align:right;'>"+5+ "</td><td style='text-align:right;'>"+(percentageachievedbilling*5)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Avg Weekly Billing</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(actualweeklyBilling))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Customer Visit</td><td>-</td><td style='text-align:right;'>"+formatNumber(ytdVisttarget*currWeek)+ "</td><td style='text-align:right;'>"+formatNumber(ytdVistactuals)+ "</td><td>-</td><td>"+formatNumber(ytdCustVistit)+"</td><td style='text-align:right;'>"+percentageachievedcustvisit+ "</td><td style='text-align:right;'>"+5+"</td><td style='text-align:right;'>"+(percentageachievedcustvisit*5)/100+"</td></tr>"
				 +	"<tr><td style='text-align:left;' class='se-brr'>Total JIH Lost</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(totJIHLostVal))+ "</td><td>-</td><td>-</td><td>-</td><td>-</td><td>-</td></tr>"
				 +	"<tr><td style='text-align:left;width:35%;' class='se-brr'>JIH Lost with NR</td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(JIHLostNoRepse))+ "</td><td>-</td><td>-</td><td>-</td><td style='text-align:right;'>"+10+"</td><td style='text-align:right;'><a href='#' data-toggle='modal' data-target='#help-modaljihnoresp'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a>"+jihpercentageval+"</td></tr>"
				 +	"<tr><td style='text-align:left;'class='se-brr'>Gross Profit</td><td style='text-align:right;'>"+formatNumber(Math.round(gpTarget))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(ytdTargetGp))+"</td><td style='text-align:right;'>"+formatNumber(Math.round(gpActual))+ "</td><td>"+formatNumber(prcntgeGp)+ "</td><td style='text-align:right;'>"+ytdPrcntgeGp+ "</td><td style='text-align:right;'>"+percentageachievedgeGp+ "</td><td style='text-align:right;'>"+50+ "</td><td style='text-align:right;'>"+(percentageachievedgeGp*50)/100+"</td></tr>"
				// +  "<tr><td style='text-align:left;font-weight: bold;' class='se-brr'>CONVERSION RATIO  <a href='#' data-toggle='modal' data-target='#help-modal'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a></td><td class='se-blr'></td><td>-</td><td>-</td><td style='text-align:right;font-weight: bold'>"+formatNumber(converratio)+ "</td><td>-</td><td>-</td></tr>"
				// +	"<tr><td style='text-align:left;' class='se-bbr'></td><td style='text-align:left;' > <90 Days </td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(Math.round(agingbelow90))+"</td><td>-</td><td>-</td></tr>"
				// +	"<tr><td style='text-align:left;' class='se-bbtr'>OUTSTANDING-RECV </td><td style='text-align:left;font-weight: bold;background-color:#F08080;' > >90 Days </td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080;'>-</td><td style='text-align:right;font-weight: bold;background-color:#F08080'>"+formatNumber(agingabove90)+"</td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td></tr>"
				 +	"<tr><td style='text-align:left;background-color:#F08080;font-weight: bold;' >Outstanding-Recv >120 Days </td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='text-align:right;background-color:#F08080;font-weight: bold;'>"+formatNumber(Math.round(agingabove120))+"</td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='background-color:#F08080'>-</td><td style='text-align:right;background-color:#F08080'>"+20+"</td><td style='text-align:right;background-color:#F08080'><a href='#' data-toggle='modal' data-target='#help-modalfor120days'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;margin-top: 4px;'></i></a>"+billingactualtotalper+"</td></tr>"
				// +	"<tr><td class='se-btr'></td><td style='text-align:left;' > Total </td><td>-</td><td>-</td><td style='text-align:right;'>"+formatNumber(outrecv)+ "</td><td>-</td><td>-</td></tr>";
 
    			output+="</tbody></table>"; 
    			var subTtl1 =  'Conversion Ratio - '+formatNumber(converratio) +"<a href='#' data-toggle='modal' data-target='#help-modal'> <i class='fa fa-info-circle pull-right' style='color: #2196f3;font-size: 15px;padding-right: 70%;'></i></a><button type='button' class='btn btn-default' data-dismiss='modal'>Close</button>";
    			$("#salesmanager_performance_modal .modal-body").html(output);  
    			$("#salesmanager_performance_modal .modal-subtitle3").html(subTtl1);
    			$("#salesmanager_performance_modal .modal-footer").html(footerout);  
    			$("#salesmanager_performance_modal").modal("show");
    			

				  // Jquery draggable
				  $('.modal-dialog').draggable({
				      handle: ".modal-header"
				  });
    	
    			$("#salesmanager_performance_table").DataTable( {
    				dom: 'Bfrtip',
    				searching: false,
    			    ordering:  false,
    			    paging: false,
    			    info: false,
    			     buttons: [
    			         {
    			            extend: 'excelHtml5',
    			             text:      '<i class="fa fa-file-excel-o" style="color: #1979a9; font-size: 1em;">Export</i>',
    			             filename: fileName,
    			             title: ttl,
    			             messageTop: 'File Processed on : ${currCal} ,The information in this file is copyright to Faisal Jassim Group.'
    			            
    			            
    			         },
    			         {
 			        	    extend: 'print', 
 			        	    text:      '<i class="fa fa-print" style="color: #1979a9; font-size: 1em;">Print</i>',    			        	  

 			        	    title: printttl + " Conversion Ratio: "+formatNumber(converratio),
 			        	    customize: (win) => {
 			        	    	$(win.document.head).append('<style>h1 { font-size: 14px; }</style>'); // Adjust the font size of the title
 			        	    	$(win.document.body)    			        	        
 	                            .css("height", "auto")
 		        	            .css("min-height", "0");
 			        	        $(win.document.body).find( 'table' )
 			                    .addClass( 'compact' )
 			                    .css( 'font-size', 'inherit' );
 			        	        $(win.document.body).find('table').css('border-collapse', 'collapse');
 			        	        $(win.document.body).find('th, td').css('border', '1px solid black');
 			        	        $(win.document.body).find('title').css('font-size', '1px');
 			        	    }
  			         }
    			      
    			       
    			    ]
    			 } );
    		
		
	},error:function(data,status,er) {$('#laoding').hide();  alert("please click again");}});
}



function printAllSalesEngineerBillingCodes(smCode,datatype) {
    console.log("All Sales Engineer Codes: "+ smCode);
    var ttl="<b>Billing Details </i></strong></b>";
    var excelTtl="Billing Details"
    $("#s5-modal-graph .modal-title").html(ttl);
    $.ajax({ 
    	type: 'POST',
    	url: 'salesManagerPerf',  
     	data :{
     			fjtco:"allse_perf" ,
     			c1 : smCode,
     			c2 : datatype
     			},
     	traditional: true,
    	dataType: "json",
        success: function(data) {
            $('#loading').hide();          
            var output="<table id='s5-excl' class='table table-bordered small'><thead><tr>"+"<th>#</th><th>Comp Code</th><th>Week</th><th>Doc ID</th><th>Doc Date</th><th>Sm Code</th>"+
            "<th>Sm Name</th><th>Party Name</th><th>Contact</th><th>Contact No</th><th>Project Name</th>"+ " <th>Zone</th><th>Currency</th><th>Amount</th> </tr></thead><tbody>";
            var j=0;for (var i in data) { j=j+1; output+="<tr><td>"+j+"</td><td><span>" + $.trim(data[i].d1)+ "</span></td>"+
            "<td>" + $.trim(data[i].d2)+ "</td><td>" + $.trim(data[i].d3) + "</td>"+ "<td>" +$.trim(data[i].d4.substring(0, 10)).split("-").reverse().join("/")+ "</td><td>"  + $.trim(data[i].d5 )+ "</td>"+
            "<td>" + $.trim(data[i].d6 )+ "</td><td>" +$.trim( data[i].d7 )+ "</td>"+ "<td>" + $.trim(data[i].d8 )+ "</td><td>" + $.trim(data[i].d9 )+ "</td>"+ "<td>" + $.trim(data[i].d10 )+ "</td><td>" + $.trim(data[i].d12 )+ "</td>"+
            "<td>" + $.trim(data[i].d13 )+ "</td><td>" + $.trim(data[i].d14 )+ "</td></tr>"; } 
            //output+="<tr><td colspan='16'><b>Total</b></td><td><b>"+val+"</b></td></tr>"; 
            output+="</tbody></table>";  $("#s5-modal-graph .modal-body").html(output);$("#s5-modal-graph").modal("show");
            $('#s5-excl').DataTable( {
                dom: 'Bfrtip',  
                "columnDefs" : [{"targets":[1, 10], "type":"date-eu"}],
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text:      '<i class="fa fa-file-excel-o" style="color: green; font-size: 2em;"></i>',
                        filename: excelTtl,
                        title: excelTtl,
                        messageTop: 'File Processed on : ${currCal} ,The information in this file is copyright to Faisal Jassim Group.'
                        
                        
                    }
                  
                   
                ]
            } );
            
            },error:function(data,status,er) { $('#laoding').hide(); alert("please click again");} });} 
            
function printAllSalesEngineerBookingCodes(smCode) {	
    $('#loading').show(); // Ensure loading indicator is shown    
    // Create a title for the modal
    var ttl = "<b>Booking Details <strong style='color:blue;'></strong></b>";
    var excelTtl = "Booking Details ";
    
    $("#s3-modal-graph .modal-title").html(ttl);
    
    $.ajax({
        type: 'POST',
        url: 'salesManagerPerf',
        data: {
            fjtco: "allse_perfBooking",
            c1:smCode,
            //c2 : datatype
            // s1: JSON.stringify(bookingCode) // Send multiple codes as an array
        },
        dataType: "json",
        success: function(data) {
            $('#loading').hide(); // Hide loading indicator
            
            // Construct the HTML table
            var output = "<table id='s3-excl' class='table table-bordered small'><thead><tr>" +
                "<th>#</th><th>Week</th><th>Zone</th><th>Sales Code</th>" +
                "<th>Project Name</th><th>Consultant</th><th>Doc Date</th><th>Doc ID</th>" +
                "<th>LOI Received Date</th><th>Amount</th></tr></thead><tbody>";
            
            var j = 0;
            for (var i in data) {
                j = j + 1;
                output += "<tr><td>" + j + "</td>" +
                    "<td>" + $.trim(data[i].d1) + "</td>" +
                    "<td>" + $.trim(data[i].d2) + "</td>" +
                    "<td>" + $.trim(data[i].d3) + "</td>" +
                    "<td>" + $.trim(data[i].d4) + "</td>" +
                    "<td>" + $.trim(data[i].d5) + "</td>" +
                    "<td>" + $.trim(data[i].d6.substring(0, 10)).split("-").reverse().join("/") + "</td>" +
                    "<td>" + $.trim(data[i].d7) + "</td>" +        
                    "<td>" + $.trim(data[i].d8.substring(0, 10)).split("-").reverse().join("/") + "</td>" +
                    "<td>" + $.trim(data[i].d12) + "</td>" +                    
                    "</tr>";
            }
            
            output += "</tbody></table>";
            $("#s3-modal-graph .modal-body").html(output);
            $("#s3-modal-graph").modal("show");
            
            // Initialize DataTable with Excel export button
            $('#s3-excl').DataTable({
                dom: 'Bfrtip',             
                buttons: [
                    {
                        extend: 'excelHtml5',
                        text: '<i class="fa fa-file-excel-o" style="color: green; font-size: 2em;"></i>',
                        filename: excelTtl,
                        title: excelTtl,
                        messageTop: 'File Processed on : ${currCal} ,The information in this file is copyright to Faisal Jassim Group.'
                    }
                ]
            });
        },
        error: function(data, status, er) {
            $('#loading').hide(); // Hide loading indicator
            alert("Please click again");
        }
    });
}

//stage 2 detail normal se page
function s2Details() { 
	$('#laoding').show();
	var smCode = $("#scode option:selected").val(); 
var excelTtl='Stage 2 Details of Sales Engineer : ${selected_salesman_code}';
var ttl="<b>Stage 2 Details of Sales Engineer : ${selected_salesman_code} </b> ";
$("#jihv-modal-graph .modal-title").html(ttl);
$.ajax({ 
	type: 'POST',
	url: 'salesManagerPerf',  
	data: {fjtco: "s2_dt", c1:smCode},
	dataType: "json",
    success: function(data) { $('#laoding').hide();var output="<table id='jihvexport' style='height:500px;overflow-y: scroll;overflow-x: scroll;' class='table table-bordered small'><thead><tr>"+ "<th>#</th><th>Comp-Code</th><th>Week</th><th>Qtn-Date</th><th>Qtn-Code</th><th>Qtn-No</th>"+
"<th>Customer Code</th><th>Customer Name</th><th>Project Name</th><th>Consultant</th>"+"<th>Qtn Amount</th>"+ " <th>Invoicing Year</th><th>Product Type</th>  <th>Product Classfctn</th><th>Zone</th><th>Profit (%)</th></tr></thead><tbody>";
var j=0; for (var i in data) { j=j+1; output+="<tr><td>"+j+"</td><td>" + data[i].d3 + "</td>"+"<td>" + data[i].d4 + "</td><td>" + data[i].d5.substring(0, 10).split("-").reverse().join("/")+ "</td>"+ "<td>" + data[i].d6 + "</td><td>" + data[i].d7 + "</td>"+
"<td>" + data[i].d8 + "</td><td>" + data[i].d9 + "</td>"+ "<td>" + data[i].d10 + "</td><td>" + data[i].d11 + "</td><td>" + data[i].d17 + "</td>"+ "<td>" + data[i].d12.substring(0, 10).split("-").reverse().join("/") + "</td><td>" + data[i].d13 + "</td>"+
"<td>" + data[i].d14 + "</td><td>" + data[i].d15 + "</td>"+ "<td>" + data[i].d16 + "</td>"+ "</tr>"; }// output+="<tr><td colspan='15'><b>Total</b></td><td><b>"+str+"</b></td></tr>"; 
output+="</tbody></table>";

$("#jihv-modal-graph .modal-body").html(output);$("#jihv-modal-graph").modal("show"); 
$('#jihvexport').DataTable( {
    dom: 'Bfrtip',  
    "columnDefs" : [{"targets":3, "type":"date-eu"}],
    buttons: [
        {
            extend: 'excelHtml5',
            text:      '<i class="fa fa-file-excel-o" style="color: green; font-size: 2em;"></i>',
            filename: excelTtl,
            title: excelTtl,
            messageTop: 'File Processed on : ${currCal} ,The information in this file is copyright to Faisal Jassim Group.'
            
            
        }
      
       
    ]
} );

},error:function(data,status,er) {$('#laoding').hide();  alert("please click again");}});
} 
function s3Details(val){ $('#laoding').show();
var smCode = $("#scode option:selected").val(); 
var ttl="<b>Stage 3 Details of <strong style='color:blue;'><i>${selected_salesman_code} </i></strong></b>"; 
var excelTtl="Stage 3 Details of ${selected_salesman_code}";
$("#s3-modal-graph .modal-title").html(ttl);
$.ajax({ type: 'POST', url: 'salesManagerPerf', data: {fjtco: "s3_dt", c1:smCode}, dataType: "json", success: function(data) { $('#laoding').hide();
var output="<table id='s3-excl' class='table table-bordered small'><thead><tr>"+"<th>#</th><th>Week</th><th>Zone</th><th>Product Category</th><th>Product Sub Category</th>"+
"<th>Project Name</th><th>Consultant</th><th>Customer</th><th>Quotation Date</th><th>Quotation Code</th><th>Quotation No.</th>"+
" <th>Amount</th><th>Average GP</th><th>LOI Received Date</th>  <th>Exp Po Date</th><th>Invoicing Year</th></tr></thead><tbody>";
var j=0; for (var i in data) {j=j+1; output+="<tr><td>"+j+"</td><td>" + $.trim( data[i].d1) + "</td>"+ "<td>" + $.trim( data[i].d2 ) + "</td>"+
"<td>" + $.trim( data[i].d4 ) + "</td><td>" + $.trim(data[i].d5) + "</td>"+ "<td>" + $.trim(data[i].d6 )+ "</td><td>" + $.trim(data[i].d7) + "</td>"+
"<td>" + $.trim(data[i].d8) + "</td><td>" + $.trim(data[i].d9.substring(0, 10)).split("-").reverse().join("/") + "</td>"+ "<td>" + $.trim(data[i].d10) + "</td><td>" + $.trim(data[i].d11) + "</td>"+
"<td align='right'>" + formatNumber($.trim(data[i].d12))+ "</td><td>" + data[i].d13 + "</td>"+ "<td>" + $.trim(data[i].d14.substring(0, 10)).split("-").reverse().join("/") + "</td><td>" + $.trim(data[i].d15.substring(0, 10)).split("-").reverse().join("/")+ "</td>"+
"<td>" + $.trim(data[i].d16.substring(0, 10)).split("-").reverse().join("/")+ "</td>"+ "</tr>"; }
output += "</tbody></table>";
//output+="<tr><td colspan='15'><b>Total</b></td><td><b>"+val+"</b></td></tr>"; output+="</tbody></table>";  
$("#s3-modal-graph .modal-body").html(output);$("#s3-modal-graph").modal("show");
$('#s3-excl').DataTable( {
    dom: 'Bfrtip',    
    //"columnDefs" : [{"targets":[8, 13, 14], "type":"date-eu"}],
    buttons: [
        {
            extend: 'excelHtml5',
            text:      '<i class="fa fa-file-excel-o" style="color: green; font-size: 2em;"></i>',
            filename: excelTtl,
            title: excelTtl,
            messageTop: 'File Processed on : ${currCal} ,The information in this file is copyright to Faisal Jassim Group.'
            
            
        }
      
       
    ]
} );

},error:function(data,status,er) { $('#laoding').hide(); alert("please click again"); }});}
function s4Details(){ $('#laoding').show(); 
var smCode = $("#scode option:selected").val(); 
var ttl="<b>Stage 4 Details of <strong style='color:blue;'><i>${selected_salesman_code} </i></strong></b>";
var excelTtl="Stage 4 Details of ${selected_salesman_code}"
$("#s4-modal-graph .modal-title").html(ttl);$.ajax({ type: 'POST',url: 'salesManagerPerf', data: {fjtco: "s4_dt", c1:smCode}, dataType: "json",success: function(data) {
$('#laoding').hide();var output="<table id='s4-excl' class='table table-bordered small'><thead><tr>"+"<th>#</th><th>So Date</th><th>So Txn Code</th><th>Order No.</th>"+
"<th>Sales Eng.</th><th>Zone</th><th>Product Category</th><th>Product Sub Category</th><th>Project Name</th>"+ " <th>Consultant</th><th>Payment Term</th><th>Customer</th>  <th>Profit %</th><th>Balance Value</th>"+ "<th>Projected Invoice Date</th><th>Soh Location Code</th></tr></thead><tbody>";
var j=0;for (var i in data) { j=j+1; output+="<tr><td>"+j+"</td><td><span>" + $.trim(data[i].d1.substring(0, 10)).split("-").reverse().join("/")+ "</span></td>"+
"<td>" + $.trim(data[i].d2)+ "</td><td>" + $.trim(data[i].d3) + "</td>"+ "<td>" +$.trim(data[i].d4)+ " - " + $.trim(data[i].d5 )+ "</td>"+
"<td>" + $.trim(data[i].d8 )+ "</td><td>" +$.trim( data[i].d9 )+ "</td>"+ "<td>" + $.trim(data[i].d10 )+ "</td><td>" + $.trim(data[i].d11 )+ "</td>"+ "<td>" + $.trim(data[i].d12 )+ "</td><td>" + $.trim(data[i].d13 )+ "</td>"+
"<td>" + $.trim(data[i].d14 )+ "</td><td>" + $.trim(data[i].d15)+ "</td>"+ "<td>" + $.trim(data[i].d16)+ "</td>"+ "<td>" + $.trim(data[i].d17.substring(0, 10)).split("-").reverse().join("/")+ "</td>"+
"<td>" +$.trim( data[i].d18)+ "</td>"+ "</tr>"; } 
//output+="<tr><td colspan='16'><b>Total</b></td><td><b>"+val+"</b></td></tr>"; 
output+="</tbody></table>";  $("#s4-modal-graph .modal-body").html(output);$("#s4-modal-graph").modal("show");
$('#s4-excl').DataTable( {
    dom: 'Bfrtip', 
    //"columnDefs" : [{"targets":[1, 14], "type":"date-eu"}],
    buttons: [
        {
            extend: 'excelHtml5',
            text:      '<i class="fa fa-file-excel-o" style="color: green; font-size: 2em;"></i>',
            filename: excelTtl,
            title: excelTtl,
            messageTop: 'File Processed on : ${currCal} ,The information in this file is copyright to Faisal Jassim Group.'
            
            
        }
      
       
    ]
} );

},error:function(data,status,er) { $('#laoding').hide(); alert("please click again");} });} 
function s5Details(val){ $('#laoding').show(); 
var smCode = $("#scode option:selected").val(); 
var ttl="<b>Stage 5 Details of <strong style='color:blue;'><i>${selected_salesman_code} </i></strong></b>";
var excelTtl="Stage 5 Details of ${selected_salesman_code}"
$("#s5-modal-graph .modal-title").html(ttl);$.ajax({ type: 'POST',url: 'salesManagerPerf', data: {fjtco: "s5_dt", c1:smCode}, dataType: "json",success: function(data) {
$('#laoding').hide();var output="<table id='s5-excl' class='table table-bordered small'><thead><tr><th>#</th><th>Comp Code</th><th>Week</th><th>Doc ID</th><th>Doc Date</th><th>Sm Code</th>"+
"<th>Sm Name</th><th>Party Name</th><th>Contact</th><th>Contact No</th><th>Project Name</th>"+ " <th>Zone</th><th>Currency</th><th>Amount</th> </tr></thead><tbody>";
var j=0;for (var i in data) { j=j+1; output+="<tr><td>"+j+"</td><td><span>" + $.trim(data[i].d1)+ "</span></td>"+
"<td>" + $.trim(data[i].d2)+ "</td><td>" + $.trim(data[i].d3) + "</td>"+ "<td>" +$.trim(data[i].d4.substring(0, 10)).split("-").reverse().join("/")+ "</td><td>"  + $.trim(data[i].d5 )+ "</td>"+
"<td>" + $.trim(data[i].d6 )+ "</td><td>" +$.trim( data[i].d7 )+ "</td>"+ "<td>" + $.trim(data[i].d8 )+ "</td><td>" + $.trim(data[i].d9 )+ "</td>"+ "<td>" + $.trim(data[i].d10 )+ "</td><td>" + $.trim(data[i].d12 )+ "</td>"+
"<td>" + $.trim(data[i].d13 )+ "</td><td>" + $.trim(data[i].d14 )+ "</td></tr>"; } 
//output+="<tr><td colspan='16'><b>Total</b></td><td><b>"+val+"</b></td></tr>"; 
output+="</tbody></table>";  $("#s5-modal-graph .modal-body").html(output);$("#s5-modal-graph").modal("show");
$('#s5-excl').DataTable( {
    dom: 'Bfrtip',  
    "columnDefs" : [{"targets":[1, 10], "type":"date-eu"}],
    buttons: [
        {
            extend: 'excelHtml5',
            text:      '<i class="fa fa-file-excel-o" style="color: green; font-size: 2em;"></i>',
            filename: excelTtl,
            title: excelTtl,
            messageTop: 'File Processed on : ${currCal} ,The information in this file is copyright to Faisal Jassim Group.'
            
            
        }
      
       
    ]
} );

},error:function(data,status,er) { $('#laoding').hide(); alert("please click again");} });} 

function extractValue(value) { 
    // Nine Zeroes for Billions
    return Math.abs(Number(value)) >= 1.0e+9

    ? (Math.abs(Number(value)) / 1.0e+9).toFixed(2) + "B"
    // Six Zeroes for Millions 
    : Math.abs(Number(value)) >= 1.0e+6

    ? (Math.abs(Number(value)) / 1.0e+6).toFixed(2) + "M"
    // Three Zeroes for Thousands
    : Math.abs(Number(value)) >= 1.0e+3

    ? (Math.abs(Number(value)) / 1.0e+3).toFixed(2) + "K"

    : (Math.abs(Number(value))).toFixed(2);
    
}   

</script> 
<!-- page script -->

</body>
</c:when>
<c:otherwise>

        <body onload="window.top.location.href='logout.jsp'">
   
            
        </body>
  
</c:otherwise>
</c:choose>
</html>