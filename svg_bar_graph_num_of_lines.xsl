<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/2000/svg"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- global vars-->
    <xsl:variable name="songcoll" select="collection('markedup_songs')"/>
    <xsl:variable name="numSongs" select="count($songcoll//song)"/>
    <xsl:variable name="appMax1" select="max(for $lyrics in $songcoll//song return count($lyrics//line))"/>
    <!-- intervals -->    
    <xsl:variable name="Xinterval" select="100"/>
    <xsl:variable name="Yinterval" select="-20"/>
    
    <xsl:template match="/">        
        <svg xmlns="http://www.w3.org/2000/svg" width="1800" height="250" viewBox="0 0 1800 250">
            <g transform="translate(50 200)">
                <text x="90" y="-180" fill="red">Line graph of the Count of lines per song used in the project</text>
                <!--X axis: -->
                <line x1="0" y1="0" x2="{$numSongs * $Xinterval}" y2="0" stroke-width="3" stroke="black"/>
                <!--Y axis: -->
                <line x1="0" y1="0" x2="0" y2="{$appMax * $Yinterval + $Yinterval}" stroke-width="3" stroke="black"/>
                <!--Y axis hashmarks and hashlines -->
                <xsl:for-each select="1 to $appMax">
                    <xsl:variable name="HashLocator" select=". * $Yinterval"/>
                    <xsl:variable name="HashLabel" select="."/>
                    <text x="-10" y="{$HashLocator}" fill="red" text-anchor="middle"><xsl:value-of select="."/></text>
                    <line x1="0" y1="{.* $Yinterval}" x2="{$numSongs * $Xinterval}" y2="{.* $Yinterval}" stroke="red" stroke-width=".5" stroke-dasharray="10"/>
                </xsl:for-each>
                
                <xsl:for-each select="$songcoll//song">
                    <!--ebb: It's going to help us to space the dots and calculate things in between them 
             if we set a LOCAL VARIABLE to number the position() of each file as it's being processed 
             in the for-each sequence. (As usual, our "scratchpad style", we can check the value of a variable by writing it
         into the output in an XML comment.)-->
                    
                    <xsl:variable name="Pos" select="position()"/>
                    <xsl:comment>What is the value of $Pos? <xsl:value-of select="$Pos"/></xsl:comment>
                    
                    <!--X axis Poem Number labels: -->
                    <text x="{$Pos * $Xinterval - $Xinterval div 2}" y="15" fill="red" text-anchor="middle"><xsl:apply-templates select="descendant::idno"/></text>
                    
                    <!--circles to set dots: -->
                    <circle cx="{$Pos * $Xinterval - $Xinterval div 2}" cy="{count(descendant::app) * $Yinterval}"  r="3" fill="black"/>

                    <xsl:if test="$Pos ne last()">     
                        <line x1="{$Pos * $Xinterval - $Xinterval div 2}" y1="{count(descendant::app) * $Yinterval}" 
                            x2="{($Pos + 1) * $Xinterval - $Xinterval div 2}" y2="{count($songcoll//song[descendant::idno = current()//idno + 1]//app) * $Yinterval}"
                            stroke-width="2" stroke="green"/>
                    </xsl:if>
                </xsl:for-each>
                
                
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>