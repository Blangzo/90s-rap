<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/2000/svg"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    <!-- global vars -->
    <xsl:variable name="dickinsonColl" select="collection('markedup_songs')"/>
    <xsl:variable name="numPoems" select="count($dickinsonColl//TEI)"/>
    <xsl:variable name="appMax" select="max(for $file in $dickinsonColl//TEI return count($file//app))"/>
    <!--ebb: Read from the inside out: This handy little construction first makes a "for-loop" that walks through each TEI file, 
        and returns a count of its app elements. We want to know the maximum of those values to know how long to make our Y axis, so we
    wrap it in a max() function. -->    
    <xsl:variable name="Xinterval" select="100"/>
    <xsl:variable name="Yinterval" select="-20"/>
    <!--ebb: NOTICE: we set our Yinterval to a negative value, so our Y values will climb up the screen. -->
    
    <xsl:template match="/">
        <!--ebb: SCRATCHPAD: I'm just going to **output** some XML comments to help me check my variables and to estimate the size of my graph. -->
        <!--Use <xsl:comment>....</xsl:comment> to output an actual xml comment in your output file. --> 
        <xsl:comment>X axis calculation: The number of poems in the collection is: <xsl:value-of select="$numPoems"/>.
        Spreading these across the screen with an interval spacer should make my X axis this long: <xsl:value-of select="$numPoems * $Xinterval"/>
        </xsl:comment>
        <xsl:comment>Y axis calculation: the maximum count of variants in the files is: <xsl:value-of select="$appMax"/>.
     Spreading "up" the screen with an interval spacer should make my Y axis this long: <xsl:value-of select="$appMax * $Yinterval"/>.</xsl:comment>
        <!--ebb: These calculations help me estimate the dimensions of my width, height, and viewBox on the SVG root element.
        For more on viewBox, see Sara Soueidan's tutorial: https://www.sarasoueidan.com/blog/svg-coordinate-systems/
        -->
        
        <svg xmlns="http://www.w3.org/2000/svg" width="1800" height="250" viewBox="0 0 1800 250">
            <g transform="translate(50 200)">
                <text x="90" y="-180" fill="red">Line graph of the Count of Variant Passages per Poem in Emily Dickinson's Fascicle 16</text>
                <!--Let's draw the X and Y axes here. -->
                <!--X axis: -->
                <line x1="0" y1="0" x2="{$numPoems * $Xinterval}" y2="0" stroke-width="3" stroke="black"/>
                <!--NOTE: you could make x2 a numerical value here that you plug in from looking at your generated xml comments from our Scratchpad! 
            But it's always more robust to write in a calculation with your variables here, in case you ever want to CHANGE those variables.
            NOTICE: This is an Attribute Value Template: you require **a pair of curly braces**.
            -->
                <!--Y axis: -->
                <line x1="0" y1="0" x2="0" y2="{$appMax * $Yinterval + $Yinterval}" stroke-width="3" stroke="black"/>
                <!--Y axis hashmarks and hashlines -->
                <xsl:for-each select="1 to $appMax">
                    <xsl:variable name="HashLocator" select=". * $Yinterval"/>
                    <xsl:variable name="HashLabel" select="."/>
                    <text x="-10" y="{$HashLocator}" fill="red" text-anchor="middle"><xsl:value-of select="."/></text>
                    <line x1="0" y1="{.* $Yinterval}" x2="{$numPoems * $Xinterval}" y2="{.* $Yinterval}" stroke="red" stroke-width=".5" stroke-dasharray="10"/>
                </xsl:for-each>
                
                <xsl:for-each select="$dickinsonColl//TEI">
                    <xsl:variable name="Pos" select="position()"/>
                    <!-- X axis labels: -->
                    <text x="{$Pos * $Xinterval - $Xinterval div 2}" y="15" fill="red" text-anchor="middle"><xsl:apply-templates select="descendant::idno"/></text>
                    
                    <!--circles to set dots: -->
                    <circle cx="{$Pos * $Xinterval - $Xinterval div 2}" cy="{count(descendant::app) * $Yinterval}"  r="3" fill="black"/>

                    <xsl:if test="$Pos ne last()">     
                        <line x1="{$Pos * $Xinterval - $Xinterval div 2}" y1="{count(descendant::app) * $Yinterval}" 
                            x2="{($Pos + 1) * $Xinterval - $Xinterval div 2}" y2="{count($dickinsonColl//TEI[descendant::idno = current()//idno + 1]//app) * $Yinterval}"
                            stroke-width="2" stroke="green"/>
                    </xsl:if>
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>