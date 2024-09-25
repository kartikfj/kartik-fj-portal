<%-- 
    Document   : LOGISTIC DASHBOAR IMPORT P 
--%>
<%@include file="/logistic/header.jsp" %> 

 <c:choose>
 	<c:when test="${!empty fjtuser.emp_code  and fjtuser.checkValidSession eq 1 }">
 	 <style>
     .hidden-content{display:none;} 
     .slid, th.slid>input{max-width:40px !important; width:40px !important; }    
     .dateFld, th.dateFld>input{max-width:75px !important; width:75px !important; }
     .cmnFld, th.cmnFld>input{max-width:max-content !important; width:80px !important; }  
     .textAreaFld, th.textAreaFld>input{max-width:80px !important; width:80px !important; }   
  /* table tr:FIRST-CHILD + tr + tr { display:none; } */
   .sm-bx-row{display: table;  border: 1px solid #607d8b;margin-top: -10px; table-layout: fixed; margin-bottom: 2px;margin-left:15px;}
   .sm-bx-col{display: table-cell; padding:3px 10px; color:#000 !important;text-transform:uppercase;font-weight:bold;border: 1px solid #607d8b; }
   .genStyl{background:#dfe3f0;}
    /*tr.filters>th{background: white; color: #000 !important;}*/

	 </style>
 		<%@page import="com.google.gson.Gson"%>	 
 		<c:set var="controller" value="LogisticPOController" scope="page" />
 		<c:set var="deliveryController" value="LogisticDeliveryController" scope="page" />
 		<c:set var="reportController" value="LogisticReportController" scope="page" />
 		<jsp:useBean id="now" class="java.util.Date" scope="request"/> 
 		<fmt:formatDate var="currentDate" value="${now}" pattern="dd/mm/yyyy" scope="page" /> 
 		<c:set  value="${fjtuser.uname}" var="empName" scope="page" />	
 		<c:set value="FJ-Logistic" var="topHeaderFullName" scope="page" />
  		<c:set value="L" var="topHeaderShortName" scope="page" />
  		<c:set value="Import / Local PO's" var="contentTitle" scope="page" />
  		<c:set value="Logistic Dashboard" var="dashboardFullName" scope="page" /> 
  		<c:set value="Logistic Portal" var="currentPortalName" scope="page" />

 	<body class="hold-transition skin-blue sidebar-mini sidebar-collapse sidebar-mini">
 		<div class="wrapper">
		 <%@include file="/logistic/dashboardHeader.jsp" %> 
		
  	 <!-- Left side column. contains the logo and sidebar -->
  	 <aside class="main-sidebar">
   			 <!-- sidebar-->
    		<section class="sidebar">
		      <!-- Sidebar user panel --> 
		      <!-- sidebar menu -->
		      <ul class="sidebar-menu" data-widget="tree">
		        <c:if test="${fjtuser.emp_divn_code eq 'LG' or fjtuser.emp_divn_code eq 'KSALG' or  fjtuser.role eq 'mg'  }">
		         <li><a href="${reportController}"><i class="fa fa-dashboard"></i><span>Dashboard</span></a></li> 
		      </c:if>  
		         <li class="active"><a href="${controller}"><i class="fa fa-tasks"></i><span>Import / Local PO's</span></a></li>  
		         <li><a href="${deliveryController}"><i class="fa fa-truck"></i><span>Delivery</span></a></li>           
		         <li><a href="homepage.jsp"><i class="fa fa-home"></i><span>HR Portal</span></a></li>      
		      </ul>
		    </section>
		    <!-- /.sidebar -->
  	 </aside>

	  <!-- Content Wrapper. Contains page content -->
	  <div class="content-wrapper">
	    <%@include file="/logistic/contentHeader.jsp" %>  
	    <!-- Main content -->	    
		    <%--Field Staff Home Section Start--%>
		    <section class="content">
		    <c:set var="rqstscount" value="0" scope="page" />  	     
		    <%-- TABLUAR DETAILS START --%>
		   <div class="row small">
	        <div class="col-xs-12">
	          <div class="box box-primary justify-content-center">
	          <button class="btn btn-xs btn-danger" id="exportPo"><i class="fa fa-file-excel-o"></i> Export</button>
	           <span class="pull-right info-reg" style="margin-right: 25%">* It should not be full GRN </br>
	          * Supplier code should start with I or L</br>
	          * INCOTERM should be FOB,EX_FACTORY,EX_WORKS,EX-WORKS</span>
	            <%-- <div class="box-header">
	              <h3 class="box-title">Import PO</h3>
	             </div> --%>
	            <!-- /.box-header -->  
	                <div class="sm-bx-row">
				    <div class="genStyl sm-bx-col">FROM ORION</div>
				    <div class="divnStyl  sm-bx-col">DIVISION TO INTIATE</div>
				    <div class="lgStyl  sm-bx-col">LOGISTICS UPDATE</div>
				</div>
	            <div class="box-body table-responsive  padding" style="/*display:flex;*/">
	         
	              <table class="table table-bordered small bordered display nowrap"  id="displayPos">
	                
	                <thead>
	           
	                <tr>
	                  <th class="slid" >SL. No.</th> 
	                 <%--<th>Company</th>  --%>
	                  <th class="cmnFld" >PO Number</th> 
	                  <th class="dateFld">PO Date</th>
	                  <th class="cmnFld" >Supplier</th>
	                  <th class="cmnFld">Payment Term</th>
	                  <th class="cmnFld">INCOTERM</th>
<!-- 	                  <th class="divnStyl cmnFld">C&F ETA Date</th> -->
					  <th class="divnStyl cmnFld">Partial PO</th>
	                  <th class="divnStyl cmnFld">Shipment<br/>Mode</th>
	                  <th class="divnStyl cmnFld">No. Of <br/>Containers</th>
	                  <th class="divnStyl dateFld">EX Factory<br/>Date</th>
	                  <th class="divnStyl cmnFld">Re-Export</th>
	                  <th class="divnStyl cmnFld">Contact<br/>Details</th>
	                  <th class="divnStyl cmnFld">Pick-Up<br/>Location</th>
	                  <th class="divnStyl cmnFld">Final<br/>Destination/Port</th>
	                  <th class="divnStyl cmnFld">Division<br/>Remarks</th>
	                  <th class="divnStyl cmnFld">Division<br/>Initiated</th>
	                  <%--
	                  <th class="fnStyl">Payment<br/>Status</th>
	                  <th class="fnStyl">Finance<br/>Remarks</th>
	                  <th class="fnStyl">Finance<br/>Updated</th> 
	                   --%>
	                  <th class="lgStyl dateFld">ETD</th>
	                  <th class="lgStyl dateFld">ETA</th>
	                  <th class="lgStyl  textAreaFld">Shipping <br/>Doc. Status</th> 
	                  <th class="lgStyl  textAreaFld">Status<br/>of Delivery</th>
	                  <th class="lgStyl  textAreaFld">Logistic<br/>Remarks</th>	 
	                  <th class="lgStyl dateFld">Nominated<br/>On</th> 
	                  <th class="lgStyl dateFld">Currency</th>   
	                  <th class="lgStyl dateFld">Freight<br/>Charges</th>   
	                  <th class="lgStyl dateFld">Insurance<br/>Charges</th>   
	                  <th class="lgStyl dateFld">Forwarded<br/>Name</th>
	                  <th class="lgStyl cmnFld">Reference</th>
	                  <th class="lgStyl cmnFld">Logistic<br/>Updated</th> 
	                </tr>
	                </thead>
	                <tbody>
	                
	                <c:forEach var="request" items="${POLST}" >
	                <c:set var="rqstscount" value="${rqstscount + 1}" scope="page" />	               
	               
	                <tr id="row${request.id}_${request.lineNo}">
	                <td class="slid" id="${request.id}">${rqstscount}</td>
<%-- 	                  <td class="slid"  id="${request.id}">${rqstscount}</td>	                   --%>
	                  <%--<td>${request.company}</td>--%>    
	                  <td id="poNo${request.id}"  class='cmnFld'>${request.poNumber}</td>      
	                  <td id="poDt${request.id}" class="dateFld"> 
	                  		<fmt:parseDate value="${request.poDate}" var="thePoDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
	                  		<fmt:formatDate value="${thePoDate}" pattern="dd/MM/yyyy"/>
	                  </td> 
	                  <td class="dtlsHeader cmnFld"> ${fn:substring(request.supplier, 0, 7)}<c:if test="${!empty request.supplier}">..<span class="dtlsContent"  id="suplr${request.id}">${request.supplier}</span></c:if></td>
	                   <td class="dtlsHeader cmnFld"> ${fn:substring(request.paymentTerms, 0, 7)}<c:if test="${!empty request.paymentTerms}">..<span class="dtlsContent">${request.paymentTerms}</span></c:if>
	                    <input type="hidden" id="divUpdByVal${request.id}" value="${request.divnUpdatedBy}"/>
	                    <input type="hidden" id="divUpdByName${request.id}" value="${request.divnEmpName}"/>
	                     <input type="hidden" id="lineNumber${request.id}" value="${request.lineNo}"/>
	                   </td>
	                   <td class="dtlsHeader cmnFld"> ${fn:substring(request.shipmentTerm, 0, 7)}<c:if test="${!empty request.shipmentTerm}">..<span class="dtlsContent" >${request.shipmentTerm}</span></c:if></td>	                   	                   
	                 <c:choose>
	                 	<c:when test="${fjtuser.role eq 'mg' or fjtuser.emp_divn_code eq 'FN' or  fjtuser.emp_divn_code eq 'LG' or fjtuser.emp_divn_code eq 'KSALG' or  request.logisticUpdBy ne null or lgPermission eq 'view' }">
			                  <td class="divnStyl dtlsHeader cmnFld">	                  
				              </td>
<%-- 	                 		<td class="divnStyl dtlsHeader cmnFld"> ${fn:substring(request.shipmentTerm, 0, 7)}<c:if test="${!empty request.shipmentTerm}">..<span class="dtlsContent" >${request.shipmentTerm}</span></c:if></td>   --%>
<%-- 	                 		<td class="divnStyl dtlsHeader cmnFld"> ${fn:substring(request.candFETADate, 0, 7)}<c:if test="${!empty request.candFETADate}">..<span class="dtlsContent" >${request.candFETADate}</span></c:if></td> --%>
	                        <td class="divnStyl dtlsHeader cmnFld"> ${fn:substring(request.shipmentMode, 0, 9)}<c:if test="${!empty request.shipmentMode}"><span class="dtlsContent" >${request.shipmentMode}</span></c:if></td>  
	                 	  	 <td class="divnStyl"> ${request.noOfContainers}</td>
	                 		 <td class="divnStyl dateFld">
	                  			<fmt:parseDate value="${request.exFactoryDate}" var="theExFDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
	                  			<fmt:formatDate value="${theExFDate}" pattern="dd/MM/yyyy"/>
	                  			<span class="hidden-content"><fmt:formatDate value="${theExFDate}" pattern="dd/MM/yyyy"/></span>
							</td>
							<td class="divnStyl dtlsHeader cmnFld">
							<c:choose>
			                  <c:when test="${request.reExport eq 'Y' }">YES</c:when>
			                  <c:otherwise>NO</c:otherwise>
			                 </c:choose>
							</td>   
	                  		<td class="divnStyl dtlsHeader cmnFld"> ${fn:substring(request.contactDetails, 0, 7)}<c:if test="${!empty request.contactDetails}">...<span class="dtlsContent">${request.contactDetails}</span></c:if></td>  
	                  		<td class="divnStyl dtlsHeader cmnFld"> ${fn:substring(request.pickLocation, 0, 7)}<c:if test="${!empty request.pickLocation}">...<span class="dtlsContent">${request.pickLocation}</span></c:if></td>   
	                  		<td class="divnStyl dtlsHeader cmnFld"> ${fn:substring(request.finalDestination, 0, 7)}<c:if test="${!empty request.finalDestination}">...<span class="dtlsContent">${request.finalDestination}</span></c:if></td> 
	                  		<td class="divnStyl dtlsHeader cmnFld"> ${fn:substring(request.divnRemarks, 0, 7)}<c:if test="${!empty request.divnRemarks}">...<span class="dtlsContent">${request.divnRemarks}</span></c:if></td>   
	                  		<td class="divnStyl dtlsHeader cmnFld">  ${fn:substring(request.divnEmpName, 0, 9)}<c:if test="${!empty request.divnEmpName}">
	                  				<span class="dtlsContent">Last Updated By ${request.divnEmpName} <br/>  
	                   			 	  <fmt:parseDate value="${request.divnUpdatedDate}" var="theDivUpdtDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" /> 
		                    	 	 At <fmt:formatDate value="${theDivUpdtDate}" pattern="dd/MM/yyyy HH:mm"/> 
		                    	   </span>
		                    	   </c:if>
		                    </td> 
	                 	</c:when> 
	                 	<c:otherwise>
	                 	 <td class="divnStyl dtlsHeader cmnFld">				                   
				                  <c:choose>
				                  		<c:when test="${request.lineNo eq '1'}">
				                  			<button class="btn btn-xs btn-primary create-btn" onClick="createAction('${request.id}','${request.lineNo}');">+</button>
				                  		</c:when>
				                  		<c:otherwise><span id="divUpdBy${request.id}" class=""> </span></c:otherwise>
				                  </c:choose>		                   	                  
				          </td>
<%-- 	                 	  <td class="divnStyl cmnFld" style="background-color:white">${request.shipmentTerm} --%>
<%-- 	                 	  	<input type="text" id="shipTerm${request.id}"    value="${request.shipmentTerm}" autocomplete="off" /> --%>
<%-- 	                 	  	<select class="fj_mngmnt_dm_slctbx" id="shipTerm${request.id}"  required> --%>
<!-- 								  <option value="">--Select-- </option> -->
<%-- 								  <option  value="EX-WORKS" ${selectedVal == 'EX-WORKS' ? 'selected':''}> EX-WORKS</option> --%>
<%-- 					 			  <option  value="C&F" ${selectedVal == 'C&F' ? 'selected':''}> C&F</option>					  		 --%>
<!-- 						   	</select> -->
<!-- 	                 	  </td>   -->
<!-- 	                 	  <td class="divnStyl dateFld">  -->
<%-- 	                   	  	 <fmt:parseDate value="${request.candFETADate}" var="theCandFDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" /> --%>
<%-- 		                  	 <input  class="form-control form-control-xs filetrs candFETADate"   type="text" id="candFETADate${request.id}"  value="<fmt:formatDate value="${theCandFDate}" pattern="dd/MM/yyyy"/>" autocomplete="off"   required/> --%>
<!-- 	                   	  </td>  -->
	                   	  <td class="divnStyl cmnFld">   
	                   	  	 <input type="text" id="shipMode${request.id}_${request.lineNo}"    value="${request.shipmentMode}" autocomplete="off" />
	                   	  </td>  
	                 	  <td class="divnStyl cmnFld"> 
		                  <input  class="form-control form-control-xs filetrs containers"   type="text" id="containers${request.id}_${request.lineNo}"  value="${request.noOfContainers}" autocomplete="off"  pattern="[0-9]+" /></td>
		                  <td class="divnStyl dateFld">
		                  <fmt:parseDate value="${request.exFactoryDate}" var="theExFDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
		                  <input  class="form-control form-control-xs filetrs exFacDate"   type="text" id="exFacDate${request.id}_${request.lineNo}"  value="<fmt:formatDate value="${theExFDate}" pattern="dd/MM/yyyy"/>" autocomplete="off"   required/></td>
		                  <td class="divnStyl cmnFld">
		                  <c:choose>
		                  <c:when test="${request.reExport eq 'Y' }"><input  type="checkbox" id="reexport${request.id}" checked  /></c:when>
		                  <c:otherwise><input  type="checkbox" id="reexport${request.id}_${request.lineNo}"     /></c:otherwise>
		                  </c:choose>
		                  
		                  </td>
		                  <td class="divnStyl cmnFld"><textarea rows="1" class="form-control form-control-xs filetrs-txtArea"  id="contact${request.id}_${request.lineNo}"   >${request.contactDetails}</textarea></td>
		                  <td class="divnStyl cmnFld"><input type="text" id="location${request.id}_${request.lineNo}"    value="${request.pickLocation}" autocomplete="off"/></td>
		                  <td class="divnStyl cmnFld"><input type="text" id="finalDest${request.id}_${request.lineNo}"    value="${request.finalDestination}" autocomplete="off"/></td>
		                  <td class="divnStyl cmnFld"><textarea rows="1"  class="form-control form-control-xs filetrs-txtArea"  id="divRemarks${request.id}_${request.lineNo}" class="divRemarks" >${request.divnRemarks}</textarea></td>
		                  <td class="divnStyl dtlsHeader cmnFld">
		                  <button class="btn btn-xs btn-primary updateBtn" onClick="updateDivnAction('${request.id}',this);">Update</button> 
		                  <c:choose>
		                  		<c:when test="${!empty request.divnEmpName}">
		                  			<span id="divUpdBy${request.id}" class="dtlsContent"> 
				                   		Last Updated By<br/>	${request.divnEmpName} <br/>  
				                     	<fmt:parseDate value="${request.divnUpdatedDate}" var="theDivUpdtDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
				                     	On<fmt:formatDate value="${theDivUpdtDate}" pattern="dd/MM/yyyy HH:mm"/>   
		                    		</span> 
		                  		</c:when>
		                  		<c:otherwise><span id="divUpdBy${request.id}" class=""> </span></c:otherwise>
		                  </c:choose>		                   	                  
		                  </td>
	                 	</c:otherwise>
	                 </c:choose>
	                <%-- 
	                  <c:choose> 
	                 	<c:when test="${request.divnUpdatedBy ne null  and request.exFactoryDate ne null and request.contactDetails ne null and request.pickLocation ne null and fjtuser.emp_divn_code eq 'FN'}"> 
	                 		<td class="fnStyl"> 
		                 		 <select class="pmtStatus" id="pmtStatus${request.id}" >
		                 		 	<option  value="" ${request.paymentStatus eq '' ? 'selected="selected"' : ''} >Select Status</option> 
		  							<option  value="DONE" ${request.paymentStatus eq 'DONE' ? 'selected="selected"' : ''}>DONE</option> 
		  							<option  value="NOT DONE" ${request.paymentStatus eq 'NOT DONE' ? 'selected="selected"' : ''} >NOT DONE</option>
		  			      		</select>	
		  			  		</td>
	                 		 <td class="fnStyl"><textarea  rows="1"  class="form-control form-control-xs filetrs-txtArea"  id="finRemarks${request.id}"  >${request.finRemarks}</textarea></td>
	                  		<td class="fnStyl dtlsHeader">
	                  		<button class="btn btn-xs btn-primary updateBtn" onClick="updateFinAction('${request.id}');">Update</button> 
	                  		 <c:choose>
		                  		<c:when test="${!empty request.finEmpName}">
		                  			 <span id="finUpdBy${request.id}"  class="dtlsContent"> 
				                  		 Last Updated By<br/>	 ${request.finEmpName} <br/> 
				                  		  <fmt:parseDate value="${request.finUpdatedDate}" var="theFinUpdtDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
					                     On <fmt:formatDate value="${theFinUpdtDate}" pattern="dd/MM/yyyy HH:mm"/> 			                     	
	                  		  		 </span>
		                  		</c:when>
		                  		<c:otherwise><span id="finUpdBy${request.id}" class=""> </span></c:otherwise>
		                     </c:choose>
	                  		      
	                 	</c:when>
	                 	<c:otherwise>
	                 		<td class="fnStyl"> ${request.paymentStatus}  </td>
	                 		 <td class="fnStyl dtlsHeader"> ${fn:substring(request.finRemarks, 0, 7)}<c:if test="${!empty request.finRemarks}">...<span class="dtlsContent">${request.finRemarks}</span></c:if></td> 
	                 		 <td class="fnStyl dtlsHeader"> ${fn:substring(request.finEmpName, 0, 9)}<c:if test="${!empty request.finEmpName}">
	                 		 <span class="dtlsContent">
	                 		  By ${request.finEmpName} <br/>  
	                  		<fmt:parseDate value="${request.finUpdatedDate}" var="theFinUpdtDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
		                    On <fmt:formatDate value="${theFinUpdtDate}" pattern="dd/MM/yyyy HH:mm"/> 
	                 		 </span></c:if>                 
	                 		 </td>    
	                 	</c:otherwise>
	                 </c:choose>
	                 --%>                                               	                 	
	                  <c:choose>
	                 	<%-- <c:when test="${fjtuser.emp_divn_code eq 'LG'  and  request.divnUpdatedBy ne null  and   request.finUpdatedBy ne null}">	 --%>   
	                 	<c:when test="${(fjtuser.emp_divn_code eq 'LG' || fjtuser.emp_divn_code eq 'KSALG') and request.exFactoryDate ne null and request.contactDetails ne null and request.pickLocation ne null and  request.divnUpdatedBy ne null }">                      
		                  	<td class="lgStyl dateFld">  
		                  	<fmt:parseDate value="${request.expTimeDeparture}" var="theEDTDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
		                  	<input  class="form-control form-control-xs filetrs exDeptDate"   type="text" id="expDeprtr${request.id}"  value="<fmt:formatDate value="${theEDTDate}" pattern="dd/MM/yyyy"/>" autocomplete="off"   />	                  		                 		                  	 
		                  	<span class="hidden-content"><fmt:formatDate value="${theEDTDate}" pattern="dd/MM/yyyy"/></span>
		                  	</td>
		                  	<td class="lgStyl dateFld"> 
		                  	<fmt:parseDate value="${request.expTimeArrival}" var="theExATDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
		                  	<input  class="form-control form-control-xs filetrs exArrvlDate"   type="text" id="expArrvl${request.id}"  value="<fmt:formatDate value="${theExATDate}" pattern="dd/MM/yyyy"/>" autocomplete="off"   />	                  			                  	 
		                  	<span class="hidden-content"><fmt:formatDate value="${theExATDate}" pattern="dd/MM/yyyy"/></span>
		                  	</td>
		                  	<td class="lgStyl textAreaFld">
		                  	<textarea  rows="1"  class="form-control form-control-xs filetrs-txtArea"  id="lgShipDoc${request.id}" name="lgShipDoc" >${request.shipDocStatus}</textarea> 
		                  	</td>
		                    <td class="lgStyl textAreaFld">
		                  	<textarea  rows="1"  class="form-control form-control-xs filetrs-txtArea"  id="lgDeliveryStatus${request.id}" name="lgDeliveryStatus" >${request.deliveryStatus}</textarea> 
		                  	</td>
		                  	<td class="lgStyl textAreaFld">
		                  	<textarea  rows="1"  class="form-control form-control-xs filetrs-txtArea"  id="lgRemarks${request.id}" name="lgRemarks" >${request.logisticRemark}</textarea>
		                  	</td>
		                  	<td class="lgStyl dateFld"> 
			                  	<fmt:parseDate value="${request.nominatedOn}" var="theNominatedDate"  dateStyle="short"   pattern="yyyy-MM-dd" />
			                  	<input  class="form-control form-control-xs filetrs nominatedOn"   type="text" id="nominatedOn${request.id}"  value="<fmt:formatDate value="${theNominatedDate}" pattern="dd/MM/yyyy"/>" autocomplete="off"   />	                  			                  	 
			                  	<span class="hidden-content"><fmt:formatDate value="${theNominatedDate}" pattern="dd/MM/yyyy"/></span>
		                  	</td>
	                 	    <td class="lgStyl cmnFld">
	                 	    	<select class="fj_mngmnt_dm_slctbx" id="currency${request.id}"  required>
									  <option value="">--Select-- </option>
									  <option  value="AED" ${request.currency == 'AED' ? 'selected':''}>AED</option>
									  <option  value="EURO" ${request.currency == 'EURO' ? 'selected':''}>EURO</option>
									  <option  value="GBP" ${request.currency == 'GBP' ? 'selected':''}>GBP</option>
						 			  <option  value="QAR" ${request.currency == 'QAR' ? 'selected':''}>QAR</option> 
						 			  <option  value="USD" ${request.currency == 'USD' ? 'selected':''}>USD</option>				  		
							   	</select></td>	                 	    
		                  	<td class="lgStyl cmnFld"><input type="text" style="width:70px" id="freightchar${request.id}"    value="${request.freightCharges}" autocomplete="off"/></td>		                  	
		                  	<td class="lgStyl cmnFld"><input type="text" style="width:70px" id="insurancechar${request.id}"    value="${request.insuranceCharges}" autocomplete="off"/></td>
		                  	<td class="lgStyl cmnFld"><input type="text" id="forwardedName${request.id}"    value="${request.forwardedName}" autocomplete="off"/></td>
		                  	<td class="lgStyl cmnFld" id="lgRef${request.id}">${request.reference}</td> 
		                  	<td class="lgStyl dtlsHeader cmnFld">
		                  		<button class="btn btn-xs btn-primary updateBtn" onClick="updateLogsticAction('${request.id}');">Update</button>
		                  		 <c:choose>
		                  			<c:when test="${!empty request.logEmpName}">
		                  				<span id="logUpdBy${request.id}" class="lg_dtlsContent"> 
				                  			<fmt:parseDate value="${request.logisticUpdDate}" var="theLogUpdtDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" /> 		 
				                  			Last Updated By<br/>	 ${request.logEmpName} <br/> 
				                  			On <fmt:formatDate value="${theLogUpdtDate}" pattern="dd/MM/yyyy HH:mm"/>  
		                  				</span> 
		                  			</c:when>
		                  			<c:otherwise><span id="logUpdBy${request.id}"  class=""></span></c:otherwise>
		                  		</c:choose>		                  					                  					                  		
		                  	</td> 
	                 	</c:when> 
	                 	<c:otherwise>
	                 		<td class="lgStyl dateFld"> 
	                 			<fmt:parseDate value="${request.expTimeDeparture}" var="theDeptDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
			                  	<fmt:formatDate value="${theDeptDate}" pattern="dd/MM/yyyy"/> 
	                 		 </td>
		                  	<td class="lgStyl dateFld">
		                  		<fmt:parseDate value="${request.expTimeArrival}" var="theArrvlDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
			                  	<fmt:formatDate value="${theArrvlDate}" pattern="dd/MM/yyyy"/> 
		                  	</td>   
		                  	 <td class="lgStyl dtlsHeader cmnFld"> ${fn:substring(request.shipDocStatus, 0, 7)}<c:if test="${!empty request.shipDocStatus}">...<span class="lg_dtlsContent">${request.shipDocStatus}</span></c:if></td>
		                  	 <td class="lgStyl dtlsHeader cmnFld"> ${fn:substring(request.deliveryStatus, 0, 7)}<c:if test="${!empty request.deliveryStatus}">...<span class="lg_dtlsContent">${request.deliveryStatus}</span></c:if></td>
		                  	 <td class="lgStyl dtlsHeader cmnFld"> ${fn:substring(request.logisticRemark, 0, 7)}<c:if test="${!empty request.logisticRemark}">...<span class="lg_dtlsContent">${request.logisticRemark}</span></c:if></td>		                  	 
		                  	 <td class="lgStyl dateFld">
		                  		<fmt:parseDate value="${request.nominatedOn}" var="theNominatedDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
			                  	<fmt:formatDate value="${theNominatedDate}" pattern="dd/MM/yyyy"/> 
		                  	</td>
		                  	<td class="lgStyl dtlsHeader cmnFld">${request.currency}</td>		                 	
	                 	    <td class="lgStyl dtlsHeader cmnFld">${request.freightCharges}</td>		                  	
		                  	<td class="lgStyl dtlsHeader cmnFld">${request.insuranceCharges}</td>
		                  	<td class="lgStyl dtlsHeader cmnFld">${request.forwardedName}</td>
		                  	 <td class="lgStyl dtlsHeader cmnFld" >
		                  	 <c:choose>
		                  	<c:when test="${request.reference ne null}">${fn:substring(request.reference, 0, 9)}</c:when>
		                  	<c:otherwise>${fn:substring(request.id, 0, 9)}</c:otherwise>
		                  	</c:choose> 
		                  	 ..<span class="lg_dtlsContent" id="lgRef${request.id}">
		                  	<c:choose>
		                  	<c:when test="${request.reference ne null}">${request.reference}</c:when>
		                  	<c:otherwise>${request.id}</c:otherwise>
		                  	</c:choose> 
		                  	 </span></td>  	                  	
		                  	<td class="lgStyl dtlsHeader cmnFld"> ${fn:substring(request.logEmpName, 0, 9)} <br/>
		                  	<c:if test="${!empty request.logEmpName}">
		                  	<span class="lg_dtlsContent">By  ${request.logEmpName}<br/>
		                  	<fmt:parseDate value="${request.logisticUpdDate}" var="theLogUpdtDate"  dateStyle="short"   pattern="yyyy-MM-dd HH:mm" />
		                    On <fmt:formatDate value="${theLogUpdtDate}" pattern="dd/MM/yyyy HH:mm"/> 
		                  	</span></c:if>
		                  	
		                  	 </td> 
	                 	</c:otherwise>
	                  </c:choose>	                  	                 
	                </tr>
	               </c:forEach>      
	              </tbody></table>
	              <div id="exclData" style="display:none;"></div>
	            </div>
	            <!-- /.box-body -->
	          </div>
	          <!-- /.box -->
	        </div>
	      </div>
		  <%-- TABULAR DETAILS END --%> 
		    </section>
		    <%--Field Staff Home Section End --%>	        
	    <div id="laoding" class="loader" ><img src="././resources/images/wait.gif"></div> 
	    <!-- /.content -->
	   </div>   
  	<!-- /.content-wrapper -->
	<%@include file="/logistic/footer.jsp" %> 
	<!-- page script start -->
	</div>
<script>
var _url = 'LogisticPOController';
var _method = "POST"; 
var poList = <%=new Gson().toJson(request.getAttribute("POLST"))%>;  
var exportTable = "<table class='table' id='exclexprtTble'><thead>"; 
var table;
$(function(){ 
	 $('.loader').hide();	 
	 $(".orderAckDate, .exFacDate, .exDeptDate, .exArrvlDate").datepicker({ "dateFormat" : "dd/mm/yy", yearRange: "2019:2030", minDate : -7});
	 $(".nominatedOn").datepicker({ "dateFormat" : "dd/mm/yy", yearRange: "2019:2030"});
	 $("#todate").datepicker({"dateFormat" : "dd/mm/yy",maxDate : 0 });
	  $('#displayPos thead tr')
      .clone(true)
      .addClass('filters')
      .appendTo('#displayPos thead');
	 $('#displayPos').DataTable({  
	        'paging'      : true,
	        'lengthChange': false,
	        'searching'   : true,
	        'ordering'    : true,
	        'info'        : false,
	       // "lengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
	        "columnDefs" : [{"targets":[2, 8, 15, 16], "type":"date-eu"}], 
	          responsive: true,
	    	  orderCellsTop: true,
	          fixedHeader: true, 

		        'autoWidth'   : false,
	    	 initComplete: function () {
 	            var api = this.api();
 	 
 	            // For each column
 	            api
 	                .columns()
 	                .eq(0)
 	                .each(function (colIdx) {
 	                    // Set the header cell to contain the input element
 	                    var cell = $('.filters th').eq(
 	                        $(api.column(colIdx).header()).index()
 	                    );
 	                    var title = $(cell).text();
 	                   $(cell).html('<input type="text" placeholder="' + title + '" />');
 	 
 	                    // On every keypress in this input
 	                    $(
 	                        'input',
 	                        $('.filters th').eq($(api.column(colIdx).header()).index())
 	                    )
 	                        .off('keyup change')
 	                        .on('keyup change', function (e) {
 	                            e.stopPropagation();
 	 
 	                            // Get the search value
 	                            $(this).attr('title', $(this).val());
 	                            var regexr = '({search})'; //$(this).parents('th').find('select').val();
 	 
 	                            var cursorPosition = this.selectionStart;
 	                            // Search the column for that value
 	                            api
 	                                .column(colIdx)
 	                                .search(
 	                                    this.value != ''
 	                                        ? regexr.replace('{search}', '(((' + this.value + ')))')
 	                                        : '',
 	                                    this.value != '',
 	                                    this.value == ''
 	                                )
 	                                .draw();
 	 
 	                            $(this)
 	                                .focus()[0]
 	                                .setSelectionRange(cursorPosition, cursorPosition);
 	                        });
 	                });
 	        },    
	 } );   
	 
	 exportTable += "<tr><th>Company</th> <th >PO Number</th><th>PO Date</th><th>Supplier</th> <th>Payment Term</th> <th>INCOTERM</th>  <th>Shipment Mode</th>"+
	 "<th>No. Of Containers</th> <th>EX Factory Date</th>  <th>Contact Details</th>  <th>Pick-Up Location</th><th>Final Destination/Port </th>"+
	 "<th>Division Remarks</th><th>Division Initiated By</th> <th>Division Updated Date</th>  <th>Payment Status</th>   <th>Finance Remarks</th> <th>Finance Updated By</th><th>Finance Updated Date</th>"+
	 "<th>ETD</th><th>STA</th><th>Shipping Doc. Status</th> <th>Logistic Remarks</th><th>Nominated On</th><th>Currency</th><th>Freight Charges</th><th>Insurance Charges</th><th>Forwarded Name</th><th>Logistic Updated By</th><th>Logistic Updated Date</th>"+
	 "</tr></thead><tbody>";	 
	 poList.map(item =>{
		 console.log("date== "+item.poNumber  +" ,,  "+ item.nominatedOn +" ,, "+item.expTimeArrival)
		 exportTable +="<tr>";
		 exportTable +="<td>"+checkValidOrNot(item.company)+"</td><td>"+checkValidOrNot(item.poNumber)+"</td><td>"+checkValidOrNotDate(item.poDate)+"</td><td>"+checkValidOrNot(item.supplier)+"</td><td>"+checkValidOrNot(item.paymentTerms)+"</td><td>"+checkValidOrNot(item.shipmentTerm)+"</td><td>"+checkValidOrNot(item.shipmentMode)+"</td>"; 
		 exportTable +="<td>"+checkValidOrNot(item.noOfContainers)+"</td><td>"+checkValidOrNotDate(item.exFactoryDate)+"</td><td>"+checkValidOrNot(item.contactDetails)+"</td><td>"+checkValidOrNot(item.pickLocation)+"</td><td>"+checkValidOrNot(item.finalDestination)+"</td><td>"+checkValidOrNot(item.divnRemarks)+"</td><td>"+checkValidOrNot(item.divnEmpName)+"</td>"; 
		 exportTable +="<td>"+checkValidOrNotDate(item.divnUpdatedDate)+"</td><td>"+checkValidOrNot(item.paymentStatus)+"</td><td>"+checkValidOrNot(item.finRemarks)+"</td><td>"+checkValidOrNot(item.finEmpName)+"</td><td>"+checkValidOrNotDate(item.finUpdatedDate)+"</td><td>"+checkValidOrNotDate(item.expTimeDeparture)+"</td>";
		 exportTable +="<td>"+checkValidOrNotDate(item.expTimeArrival)+"</td><td>"+checkValidOrNotDate(item.shipDocStatus)+"</td><td>"+checkValidOrNot(item.logisticRemark)+"</td><td>"+checkValidOrNotDate(item.nominatedOn)+"</td><td>"+checkValidOrNot(item.currency)+"</td><td>"+checkValidOrNot(item.freightCharges)+"</td><td>"+checkValidOrNot(item.insuranceCharges)+"</td><td>"+checkValidOrNot(item.forwardedName)+"</td><td>"+checkValidOrNot(item.logEmpName)+"</td><td>"+checkValidOrNotDate(item.logisticUpdDate)+"</td>"; 
		 exportTable +="</tr>";
	 });
	 exportTable +="</tbody></table>";  
	 $("#exclData").html(exportTable);    
	 table = $('#exclexprtTble').DataTable({   dom: 'Bfrtip',  
		   buttons: [{ extend: 'excelHtml5', text:      '<i class="fa fa-file-excel-o" style="color: #fff; font-size: 1.5em;">Download</i>', filename: 'LOGISTIC DASHBORD IMPORT PO REPORT - ${currCal}',
		   title: 'LOGISTIC DASHBORD IMPORT PO REPORT - ${currCal}', messageTop: 'The information in this file is copyright to FJ-Group.'}]
	} ); 
	
	 $("#exportPo").on("click", function() {
		    table.button( '.dt-button' ).trigger();
		});
});
function preLoader(){ $('.loader').show();}

// 	var containers = parseInt($.trim(document.getElementById('containers'+id+'').value));
// 	var exFacDate = $.trim(document.getElementById('exFacDate'+id+'').value);
// 	var contact = $.trim(document.getElementById('contact'+id+'').value);
//  	var reexport = $.trim(document.getElementById('reexport'+id+'').checked); 
// 	var location = $.trim(document.getElementById('location'+id+'').value);
// 	var divRemarks = $.trim(document.getElementById('divRemarks'+id+'').value); 
// 	var shipTerm,candFETADate;
// 	var shipMode = $.trim(document.getElementById('shipMode'+id+'').value); 
// 	var finalDest = $.trim(document.getElementById('finalDest'+id+'').value); 
// 	//var candFETADate = $.trim(document.getElementById('candFETADate'+id+'').value); 
// 	var poNo = $.trim(document.getElementById('poNo'+id+'').innerHTML); 
// 	var poDt = $.trim(document.getElementById('poDt'+id+'').innerHTML); 
// 	var supplr = $.trim(document.getElementById('suplr'+id+'').innerHTML); 
// 	var divAction = $.trim(document.getElementById('divUpdBy'+id+'').innerHTML);  
// 	var reference = $.trim(document.getElementById('lgRef'+id+'').innerHTML); 
// 	var type = 0; 
// 	var lineNumber = document.getElementById('lineNumber' + id).value;
	function updateDivnAction(id,button) {
		// var lineNo = $.trim(document.getElementById('lineNumber'+id).value);
		const buttonId = button.id;
    console.log("Button ID:", buttonId);
    
    // Alternatively, you can also get the ID of the closest row or another element if needed
    const rowId = $(button).closest('tr').attr('id');
    var lineNo = rowId.split('_').pop();
    console.log("Row ID:", rowId);
		 // let currentRow = $('#row' + requestId + '_' + lineNo);
    // Identify the specific row based on PO ID and lineNo
    var row = $('#row' + id + '_' + lineNo);
	alert(lineNo);
    if (row.length) {
        // Capture data from the row
        //var poNo = $.trim(row.find('#poNo' + id).text());
        var poNo = document.getElementById('poNo'+id+'').innerHTML;
        var poDt = $.trim(row.find('#poDt' + id).text());
        var supplr = $.trim(row.find('#supplr' + id).text());
        var exFacDate = $.trim(row.find('#exFacDate' + id).val());
        
        var contact = $.trim(document.getElementById('contact'+id+'_'+lineNo).value); 
        var reexport =  $.trim(document.getElementById('reexport' + id+'_'+lineNo).checked); 
        var location = $.trim(document.getElementById('location'+id+'_'+lineNo).value); 
        var divRemarks =  $.trim(document.getElementById('divRemarks'+id+'_'+lineNo).value); 
        //var shipMode = $.trim(row.find('#shipMode' + id+'_'+lineNo).text()); 
        var shipMode = $.trim(document.getElementById('shipMode'+id+'_'+lineNo).value); 
        //var finalDest = $.trim(row.find('#finalDest' + id).val());
        var containers =  $.trim(document.getElementById('containers'+id+'_'+lineNo).value); 
        var finalDest = $.trim(document.getElementById('finalDest'+id+'_'+lineNo).value); 
        var reference = $.trim(document.getElementById('lgRef'+id+'').innerHTML); 
        var divAction = $.trim(document.getElementById('divUpdBy'+id+'').innerHTML);  
        var type = divAction ? 1 : 0; // Determine type based on divAction existence
		alert(shipMode);
        // Debugging alerts to track values
        console.log("PO Number: ", poNo);
        console.log("Ex Factory Date: ", exFacDate);
        console.log("Contact: ", contact);
        console.log("Location: ", location);
        console.log("Ship Mode: ", shipMode);
        console.log("Containers: ", containers);

        // Validate necessary fields
        if (exFacDate && contact && location) {
            if (checkDateFormat(exFacDate, "Ex Factory")) {
            	if ((confirm('Are You sure, You Want to update this details!'))) { 
			 		preLoader();		   
					$.ajax({
					 type: _method,
			    	 url: _url, 
			    	 data: {action: "updudea", podd0:id, podd1:filteredContainers, podd2:exFacDate, podd3:contact, podd4:location, podd5:divRemarks,   podd6:poNo, podd7:poDt, podd8:supplr, podd9:shipTerm, podd10:shipMode, podd11:finalDest, podd12:type, podd13:reexport, podl4:reference,podd15:candFETADate },
			    	 success: function(data) {  
			    	 $('.loader').hide();
			    	 if (parseInt(data) == 1) {	 
			    		 var updateBox = document.getElementById('divUpdBy'+id+''); 
			    		 if(!updateBox.classList.contains("dtlsContent")){updateBox.classList.add("dtlsContent");}	
			    		 updateBox.innerHTML='<b class="updatedStyl">Updated Successfully!.</b> By<br/> <b class="text-primary">${empName}</b> <br/> On <b class="text-primary">'+moment().format("DD/MM/YYYY, h:mm:ss a")+'</b>';
			    		  alert("Details updated successfully!.");
			    		  return true;
			            }else if(parseInt(data) == 0){ 
			            	alert("Details not updated,Please refresh the page!.");
			            	 return false;
			            }else if(parseInt(data) == 40){ 
			            	alert("Please fill Ex. Factory Date, Contact person and Pickup location");
			            	 return false;
			            }else{
			            	 alert("Details not updated,Please refresh the page!.");
			            	 return false;
			            }
			     		},error:function(data,status,er) {
			    		 $('#loading').hide();
			    		 alert("Details not updated,Please refresh the page!.");
			    		 return false;	 
			     		}
			   			}); 
			 		} else {
                    return false; // User cancelled update
                }
            } else {
                alert('Please fill in a correct Ex. Factory Date.');
            }
        } else {
            alert('Please fill in Ex. Factory Date, Contact person, and Pickup location.');
        }
    } else {
        console.error('Row with ID #' + id + ' and lineNo ' + lineNo + ' not found.');
    }
}
function updateFinAction(id){  
	var status = $.trim(document.getElementById('pmtStatus'+id+'').value); 
	var finRemarks = $.trim(document.getElementById('finRemarks'+id+'').value); 
	if( (status ||  finRemarks) && (status === 'DONE' || status === 'NOT DONE' || status === '') ){	 
			if ((confirm('Are You sure, You Want to update this details!'))) { 
				 preLoader();		   
					$.ajax({
					 type: _method,
			    	 url: _url, 
			    	 data: {action: "upfudea", podf0:id, podf1:status, podf2:finRemarks  },
			    	 success: function(data) {    
			    	 $('.loader').hide();
			    	 if (parseInt(data) == 1) {	 
			    		 var updateBox = document.getElementById('finUpdBy'+id+'');
			    		 if(!updateBox.classList.contains("dtlsContent")){updateBox.classList.add("dtlsContent");}
			    		 updateBox.innerHTML='<b class="updatedStyl">Updated Successfully!.</b> By<br/> <b class="text-primary">${empName}</b> <br/> On <b class="text-primary">'+moment().format("DD/MM/YYYY, h:mm:ss a")+'</b>';			    		 			    		
			    		  alert("Details updated successfully!.");
			    		  return true;
			            }else if(parseInt(data) == 0){ 
			            	alert("Something went wrong. Please refresh the page to see updated details");
			            	 return false;
			            }else{
			            	 alert("Details not updated,Please refresh the page!.");
			            	 return false;
			            }
			     		},error:function(data,status,er) {  
			    	 		 $('.loader').hide();
			    			 alert("Details not updated,Please refresh the page!.");
			    	 		 return false;	 
			     		}
			   		}); 
			 }else{return false;}  
	}else{alert('No Data Entered');}
	
}
function updateLogsticAction(id){  
	var departureDate = $.trim(document.getElementById('expDeprtr'+id+'').value);
	var arrivalDate = $.trim(document.getElementById('expArrvl'+id+'').value); 
	var remarks = $.trim(document.getElementById('lgRemarks'+id+'').value);
	var reference = $.trim(document.getElementById('lgRef'+id+'').innerHTML);
	var poNo = $.trim(document.getElementById('poNo'+id+'').innerHTML);
	var divnEmpCode = $.trim(document.getElementById('divUpdByVal'+id+'').value);  
	var divnEmpname = $.trim(document.getElementById('divUpdByName'+id+'').value);  
	var shipDocStatus = $.trim(document.getElementById('lgShipDoc'+id+'').value);
	var deliveryStatus = $.trim(document.getElementById('lgDeliveryStatus'+id+'').value);  
	var nominatedOn = $.trim(document.getElementById('nominatedOn'+id+'').value);
	var currencyType = $.trim(document.getElementById('currency'+id+'').value);
	var freightCharges = $.trim(document.getElementById('freightchar'+id+'').value);
	var insuranceCharges = $.trim(document.getElementById('insurancechar'+id+'').value);
	var forwardedName = $.trim(document.getElementById('forwardedName'+id+'').value);
	
	if(currencyType == null || currencyType == ''){
		alert(" Please select Currency");		
		return false;
	}
	if(freightCharges != null){
		if(/^[0-9-]*$/.test(freightCharges) == false){
			alert("Please enter only numbers in freightCharges ");
		    return false;
		}
	}
	if(insuranceCharges != null){
		if(/^[0-9-]*$/.test(insuranceCharges) == false){
			alert("Please enter only numbers in insuranceCharges ");
		    return false;
		}
	}
	if(departureDate|| arrivalDate || remarks || reference){ 
		if (checkDateFormat(departureDate, "Departure") && checkDateFormat(arrivalDate, "Arrival")) {
			if(confirm('Are You sure, You Want to update this details!')) { 
			 preLoader();		   
				$.ajax({
					 type: _method,
			    	 url: _url, 
			    	 data: {action: "upludea", podl0:id, podl1:departureDate, podl2:arrivalDate, podl3:remarks, podl4:reference, podl5:poNo, podl6: divnEmpCode, podl7:divnEmpname, podl8:shipDocStatus,podl9:deliveryStatus,podl10:nominatedOn,podl11:currencyType,podl12:freightCharges,podl13:insuranceCharges,podl14:forwardedName  },
			     success: function(data) {  
			    	 $('.loader').hide();
			    	 if (parseInt(data) == 1) {	 
			    		 var updateBox = document.getElementById('logUpdBy'+id+'');
			    		 if(!updateBox.classList.contains("lg_dtlsContent")){updateBox.classList.add("lg_dtlsContent");}		    		 
			    		 updateBox.innerHTML='<b class="updatedStyl">Updated Successfully!.</b> By<br/> <b class="text-primary">${empName}</b> <br/> On <b class="text-primary">'+moment().format("DD/MM/YYYY, h:mm:ss a")+'</b>';
			    		  alert("Details updated successfully!.");
			    		  return true;
			            }else if(parseInt(data) == 0){
			            	alert("Something went wrong. Please refresh the page to see updated details");
			            	 return false;
			            }else{
			            	 alert("Details not updated,Please refresh the page!.");
			            	 return false;
			            }
			     },error:function(data,status,er) {
			    	 $('.loader').hide();
			    	 alert("Your field visit is not deleted,Please refresh the page!.");
			    	 return false;	 
			     }
			   }); 
			 }else{return false;} 
		}else{return false;} 
	}else{alert('No Data Entered');}
	
}
function checkDateFormat(dateStr, dateName){  
	if(dateStr){
		if(!(moment(dateStr, "DD/MM/YYYY", true).isValid())){
			 alert("Please Select Correct "+dateName+" Date.");
			return false;
		}else{
			return true;
		} 
	}else{ return true;}
}
 function checkValidOrNot(value){
	 if(typeof value === 'undefined'){
		 return "-";
	 }else{
		 return value;
	 }
 }
 function checkValidOrNotDate(value){
	 if(typeof value === 'undefined'){
		 return "-";
	 }else{
		 return $.trim(value.substring(0, 10)).split("-").reverse().join("/");
	 }
 }
 function setContainerValue(noContainers, id){
	 if(Number.isInteger(noContainers)){ 
		document.getElementById('containers'+id+'').value = noContainers;
		 return noContainers;
	 }else{
		 document.getElementById('containers'+id+'').value = 0;
		 return 0;
	 } 
 }
 $(".text_area").on('keyup', function(){
	    var value = parseInt($(this).val().replace(/\D/g,''),10); 
	    if (isNaN(value)) {
	        alert("Please enter only numbers")
	       return false;
	      }   
	    $(this).val(value.toLocaleString());
	});
/* $(document).on('click', '.create-btn', function () {
     // Get the row that contains the clicked button
     var currentRow = $(this).closest('tr');

     // Clone the row
     var clonedRow = currentRow.clone();

     // Insert the cloned row after the current row
     currentRow.after(clonedRow);
 });*/
 function createAction(requestId, lineNo) {
	    console.log("Creating row for ID: " + requestId);
	    
	    // Get the current row based on the request ID and line number
	    let currentRow = $('#row' + requestId + '_' + lineNo);

	    if (currentRow.length) {
	        // Get the current line number and increment it
	        let newLineNo = parseInt(lineNo) + 1;

	        // Clone the row
	        let clonedRow = currentRow.clone();

	        // Update the new cloned row's lineNo (id and any other references)
	        clonedRow.attr('id', 'row' + requestId + '_' + newLineNo);  // Update row ID to reflect new line number

	        // Update the lineNo input field in the cloned row
	        clonedRow.find('.lineNo').attr('id', 'lineNumber' + requestId + '_' + newLineNo);
    		clonedRow.find('.lineNo').val(newLineNo); 

	        // Update any other IDs and name attributes in the cloned row that need to be unique
	        clonedRow.find('[id]').each(function() {
            let originalId = $(this).attr('id');
            if (originalId) {
                let newId = originalId.replace('_' + lineNo, '_' + newLineNo);
                $(this).attr('id', newId);
            }
       		 });

        // Update any input fields to have the new line number
       	 clonedRow.find('input, select, textarea').each(function() {
            let originalName = $(this).attr('name');
            if (originalName) {
                let newName = originalName.replace('_' + lineNo, '_' + newLineNo);
                $(this).attr('name', newName);
            }
       	 });

	        // Remove the "Create" button from the cloned row
	        clonedRow.find('.create-btn').remove();

	        // Add a "Minus" button to the cloned row, in the 6th <td>
	        let removeButtonTd = $('<td class="divnStyl cmnFld"><button class="btn btn-xs btn-danger remove-btn" onclick="removeRow(this)">-</button></td>');
	        
	        // Replace the cell at the specified index (6th <td> is index 5)
	        clonedRow.find('td').eq(6).replaceWith(removeButtonTd);

	        // Clear input fields in the cloned row if any
	        clonedRow.find('input').val('');

	        // Insert the cloned row below the current one
	        clonedRow.insertAfter(currentRow);
	        //clonedRow.find('.datepicker').datepicker(); 
	         //$(".orderAckDate, .exFacDate, .exDeptDate, .exArrvlDate").datepicker({ "dateFormat" : "dd/mm/yy", yearRange: "2019:2030", minDate : -7});
			 $(".exFacDate").datepicker({ "dateFormat" : "dd/mm/yy", yearRange: "2019:2030", minDate : -7});
	        // Update the parent row's line number (this increments for further clones)
	        document.getElementById('lineNumber' + requestId).value = newLineNo;
	        console.log('New line number is: ' + newLineNo);

	    } else {
	        console.error("Row with ID #" + requestId + " and lineNo #" + lineNo + " not found.");
	    }
	}

	function removeRow(button) {
	    $(button).closest('tr').remove();
	}
</script>
<!-- page Script  end -->
</c:when>
<c:otherwise>
        <body onload="window.top.location.href='logout.jsp'">              
        </body> 
</c:otherwise>
</c:choose>
</html>