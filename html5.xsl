<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
	<!-- Imports SAM XSL templates -->
	<xsl:import href="../admin/xsl-library/master-import.xsl" />
	
	<!-- Set the character set -->
	<xsl:output method="html" encoding="utf-8" indent="yes" media-type="text/html; charset=utf-8" />
	
	<!-- Params that are passed to XSL from SAM -->
	<xsl:param name="browsemode" select="'edit'" />
	<xsl:param name="userlogin" select="1" />
	<xsl:param name="version" select="xxx" />
	<xsl:param name="menumode" select="1" />
	<xsl:param name="bucket" select="Inline" />
	<xsl:param name="debug" select="1" />
	<xsl:param name="debugtext" select="1" />
	<xsl:param name="messagetext" />
	<xsl:param name="action" />
	<xsl:param name="cwidth" />

	<!-- Some handy variables for later -->
	<xsl:variable name="myHomePageID"><xsl:value-of select="/SAM/page/navigation/breadcrumb[position() = 2]/@link-id" /></xsl:variable>
	<xsl:variable name="myPrimaryPageID"><xsl:value-of select="/SAM/page/navigation/breadcrumb[position() = 3]/@link-id" /></xsl:variable>
	<xsl:variable name="mySecondaryPageID"><xsl:value-of select="/SAM/page/navigation/breadcrumb[position() = 4]/@link-id" /></xsl:variable>
	<xsl:variable name="hasSidebar"><xsl:if test="count(/SAM/page/chunk/meta[@name='Content-Group' and value='Sidebar']) &gt; 0">true</xsl:if></xsl:variable>

	<!-- The entry point for the template -->
	<xsl:template match="/SAM">
	
		<!-- Set the DOCTYPE targeting HTML5 -->
		<xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
		
		<!-- HTML tag with conditional classes for "those" browsers -->
		<xsl:text disable-output-escaping='yes'><![CDATA[
			<!--[if lt IE 7 ]><html lang="en" class="ie6"> <![endif]-->
			<!--[if IE 7 ]><html lang="en" class="ie7"> <![endif]-->
			<!--[if IE 8 ]><html lang="en" class="ie8"> <![endif]-->
			<!--[if IE 9 ]><html lang="en" class="ie9"> <![endif]-->
			<!--[if (gt IE 9)|!(IE)]><!--><html lang="en"><!--<![endif]-->
		]]></xsl:text>
		
			<head>
				
				<!-- SAM code and cache controls -->
				<xsl:if test="@directive = 'admin'">
					<meta http-equiv="Cache-Control" content="no-cache" />
					<meta http-equiv="expires" content="-1" />
					<xsl:call-template name="admin-script" />
				</xsl:if>
				
				<!-- Charset and browser compatability tags -->
				<meta charset="UTF-8" />
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
				
				<!-- We use the page title from SAM. That can be prepended to or altered here -->
				<title><xsl:value-of select="/SAM/page/title" disable-output-escaping="yes" /></title>
				
				<!-- Canonical tag -->
				<link rel="canonical">
					<xsl:attribute name="href">
						<xsl:value-of select="/SAM/sites/site[@root-pageid = $myHomePageID]/publish-url" />
						<xsl:text>/</xsl:text>
						<xsl:value-of select="/SAM/navigation/link[@id = /SAM/page/@id]/href" />
					</xsl:attribute>
				</link>
				
				<!-- Common meta tags -->
				<xsl:choose>
					<xsl:when test="(/SAM/page/@noindex = 1 and /SAM/page/@nofollow = 1) or @directive != 'publish'">
						<meta name="robots" content="nofollow, noindex, noarchive" />
					</xsl:when>
					<xsl:when test="/SAM/page/@noindex = 0 and /SAM/page/@nofollow = 1">
						<meta name="robots" content="nofollow" />
					</xsl:when>
					<xsl:when test="/SAM/page/@noindex = 1 and /SAM/page/@nofollow = 0">
						<meta name="robots" content="noindex, noarchive" />
					</xsl:when>
				</xsl:choose>
				<meta name="description" content="" />
				<meta name="author" content="" />
				<meta name="viewport" content="width=device-width, initial-scale=1.0" />
				
				<!-- Favicon and touch icon links -->
				<!--<link rel="shortcut icon" href="/favicon.ico" />-->
				<!--<link rel="apple-touch-icon" href="/apple-touch-icon.png" />-->
				
				<!-- These meta keywords and description fields concatenate chunk and page metadata that is defined in SAM -->
				<meta name="Keywords"><xsl:attribute name="content"><xsl:for-each select="/SAM/page/keywords"><xsl:value-of select="." /></xsl:for-each><xsl:for-each select="/SAM/page/chunk/meta[@name = 'Keywords']"><xsl:value-of select="value" /></xsl:for-each></xsl:attribute></meta>
				<meta name="Description"><xsl:attribute name="content"><xsl:for-each select="/SAM/page/description"><xsl:value-of select="." /></xsl:for-each><xsl:for-each select="/SAM/page/chunk/meta[@name = 'Description']"><xsl:value-of select="value" /></xsl:for-each></xsl:attribute></meta>		
				
				<!-- This calls all stylesheets that are linkes in SAM. Stylesheets may be linkes with sites, pages or even content chunks -->
				<xsl:call-template name="getStyles" />
				
				<!-- Boilerplate styles -->
				<style type="text/css">
					/* This style definition is necessary for IE to render these elements properly */
					article,aside,details,figcaption,figure,footer,header,hgroup,menu,nav,section{display:block;}
					
					/* All these styles should be replaced */
					body {margin:0;padding:0;font-family:verdana,arial,sans-serif;font-size:12px;}
					p {margin-top:0;}
					header {background-color:#ddd;height:140px;}
					section {position:relative;margin:24px 0 0 0;float:left;width:768px;}
					.hasSidebar section {width:508px;}
					aside { float:right;width:240px;margin-top:24px;}
					footer {background-color:#ddd;}
					nav.primaryNav {background-color:#888;}
					nav.primaryNav ul { list-style-type:none;margin:0;}
					nav.primaryNav ul li { float:left;padding:8px;margin:0 2px;border-style:solid;border-width:1px;border-color:#666;background-color:#ddd;}
					nav.leftNav {position:relative;float:left;width:240px;margin-top:24px;}
					nav.leftNav ul { list-style-type:none; margin:0;padding:4px 0 0 24px;}
					nav.leftNav ul li { padding:2px 0 2px 3px;}
					nav.breadcrumbs {background-color:#ccc;}
					nav.breadcrumbs ul { margin:0;list-style-type:none;}
					nav.breadcrumbs ul li { float:left;padding:4px;margin:0 2px;border-style:solid;border-width:0 0 0 1px;border-color:#666;}
					.footerCol {width:180px;padding:20px 20px 10px 0;float:left;}
					footer ul { padding:0;margin:0;list-style-type:none;}
					footer ul li {margin:0;padding:2px 0 2px 3px;}
					.pageContainer {background-color:#aaa;}
					.pageWidth {width:1028px;margin:auto;}
					.clear {clear:both;}
					.content {background-color:#fff;}
				</style>
				
				<!-- call to Remy Sharp's HTML5 Shim for IE -->
				<xsl:text disable-output-escaping='yes'><![CDATA[
				<!--[if lt IE 9]><script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
				]]></xsl:text>
				
				<!-- Call to Modernizr (more: http://www.modernizr.com/) -->
				<script src="/js/modernizr-1.7.min.js"></script>
			
			</head>
			
			<body>
				<!-- Add class names for primary, secondary and active pages. Also adds class for home page and inidcator for if the page has a sidebar -->
				<xsl:attribute name="class">primary<xsl:value-of select="$myPrimaryPageID" /> secondary<xsl:value-of select="$mySecondaryPageID" /> pid<xsl:value-of select="/SAM/page/@id" /> sam<xsl:value-of select="@directive"/>
    				<xsl:if test="/SAM/page/@id = $myHomePageID"> home</xsl:if>
    				<xsl:if test="$hasSidebar = 'true'"> hasSidebar</xsl:if>
    			</xsl:attribute>
    			
    			<!-- SAM Administration tools -->
    			<xsl:call-template name="SAM-admin" />
    			
    			<!-- The body of the page -->
    			<div class="pageContainer">
					<xsl:call-template name="header" />
					<xsl:call-template name="primaryNav" />
    				<div class="content pageWidth">
						<xsl:call-template name="leftNav" />
						<xsl:call-template name="inline" />
						<xsl:call-template name="sidebar" />
						<div class="clear"></div>
					</div>
					<xsl:call-template name="breadcrumbs"></xsl:call-template>
    				<xsl:call-template name="footerNav"></xsl:call-template>
    			</div>
				
				<!-- Call to jQuery with backup call to local copy if Google API fails. Also includes noConflict which is mandatory in SAM for the time being (conflicts with Prototype) -->
				<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
				<script><xsl:text disable-output-escaping="yes"><![CDATA[!window.jQuery && document.write(unescape('%3Cscript src="/js/jquery-1.7.1.min.js"%3E%3C/script%3E'))]]></xsl:text></script>
				<script>jQuery.noConflict();</script>
				
				<!-- Call to your javascript -->
				<!--<script src="/js/yourscript.js"></script>-->
				
				<!-- Call to PNG Fix for IE 6 -->
				<xsl:text disable-output-escaping='yes'><![CDATA[
				<!--[if lt IE 7 ]><script src="/js/dd_belatedpng.js"></script><script>DD_belatedPNG.fix('img, .png_bg');</script><![endif]-->
				]]></xsl:text>
				
				<!-- Google Analytics code -->
				<!--<script>
					var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']]; // Change UA-XXXXX-X to be your site's ID
					(function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];g.async=1;
					g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
					s.parentNode.insertBefore(g,s)}(document,'script'));
				</script>-->
				
			</body>		
		
		<!-- Closing html tag -->
		<xsl:text disable-output-escaping="yes"><![CDATA[</html>]]></xsl:text>
		
	</xsl:template>
	
	<!-- Page header. Here we wrap the header around a <div class="pageWidth"> to give us an element that extends into margins but contains the contents within the page width -->
	<xsl:template name="header">
		<header>
			<div class="pageWidth">
				<p>Header</p>
			</div>
		</header>
	</xsl:template>

	<!-- Primary Navigation. Uses pagewidth trick described above -->
	<xsl:template name="primaryNav">
		<nav class="primaryNav">
			<div class="pageWidth">
				<xsl:call-template name="ulNavigation" />
				<div class="clear" />
			</div>
		</nav>
	</xsl:template>

	<!-- Left hand navigation. This entire template is wrapped within the <div class="pageWidth"> along with inline and right sidebar. These elements do not extend into page margin -->
	<xsl:template name="leftNav">
		<nav class="leftNav">
			<xsl:call-template name="ulNavigation">
				<xsl:with-param name="parent" select="$myPrimaryPageID" />
				<xsl:with-param name="depth" select="9999" />
			</xsl:call-template>
		</nav>
	</xsl:template>

	<!-- Main content area -->
	<xsl:template name="inline">
		<section>
			<xsl:call-template name="bucket-handler">
				<xsl:with-param name="bucket-label">Inline</xsl:with-param>
			</xsl:call-template>
		</section>
	</xsl:template>

	<!-- Sidebar content area -->
	<xsl:template name="sidebar">
		<aside>
			<xsl:call-template name="bucket-handler">
				<xsl:with-param name="bucket-label">Sidebar</xsl:with-param>
			</xsl:call-template>
		</aside>
	</xsl:template>

	<!-- Breadcrumbs template. Uses same margin trick described for the header -->
	<xsl:template name="breadcrumbs">
		<nav class="breadcrumbs">
			<div class="pageWidth">
				<xsl:call-template name="ulBreadcrumbs" />
				<div class="clear" />
			</div>
		</nav>
	</xsl:template>

	<!-- Footer Navigation template. Uses same margin trick described for the header -->
	<xsl:template name="footerNav">
		<footer>
			<div class="pageWidth">
				
				<!-- Here We're just looping through the firt 5 primary pages and outputing ulNavigation for each -->
				<xsl:for-each select="/SAM/navigation/link[@parent-id = $myHomePageID and @navigable=1]">
					<xsl:if test="position() &lt; 6">
						<div class="footerCol">
							<p><xsl:call-template name="navigation-link" /></p>
							<xsl:call-template name="ulNavigation">
								<xsl:with-param name="parent" select="@id" />
								<xsl:with-param name="idPrefix" select="'footer'" />
							</xsl:call-template>
						</div>
					</xsl:if>
				</xsl:for-each>
				<div class="clear"></div>
			</div>
		</footer>
	</xsl:template>

</xsl:stylesheet>

