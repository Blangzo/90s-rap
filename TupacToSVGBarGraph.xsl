<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- global vars -->
    <!-- I was too lazy to put in new markup so I used the 4 songs with well-formed markup that were in the github folder and put them in a separate folder with my svg. It is on my github for you to see -->
    <xsl:variable name="tupacColl" select="collection('markedup_songs')"/>
    <xsl:variable name="numSongs" select="count($tupacColl//song)"/>
    <xsl:variable name="lineMax"
        select="
            max(for $file in $tupacColl//song
            return
                count($file//line))"/>
    <xsl:variable name="Xspacer" select="20"/>
    <xsl:variable name="Yinterval" select="-20"/>
    <xsl:variable name="YMax" select="$Yinterval * (($lineMax div 10) + 1)"/>
    <xsl:variable name="XMax" select="($Xspacer + $barWidth) * (($numSongs)) + $Xspacer"/>
    <xsl:variable name="barWidth" select="50"/>
    <!-- start -->
    <xsl:template match="/">
        <xsl:comment><xsl:value-of select="$lineMax"/></xsl:comment>
        <html>
            <head>
                <link rel="stylesheet" type="text/css" href="TupacToSVGBarGraph.css"/>
            </head>
            <body>
                <svg width="500" height="500" viewBox="0 0 500 500">
                    <g transform="translate(50 300)">
                        <text x="0" y="-270" fill="white">Bar Graph of the number of lines in each
                            song</text>
                        <!--X axis: -->
                        <line x1="0" y1="0" x2="{$XMax}" y2="0" stroke-width="3" stroke="black"/>
                        <!--Y axis: -->
                        <line x1="0" y1="0" x2="0" y2="{$YMax}" stroke-width="3" stroke="black"/>
                        <!-- things -->
                        <xsl:for-each select="$tupacColl//song">
                            <!-- local vars -->
                            <xsl:variable name="spos" select="position()"/>
                            <xsl:variable name="xPosition" select="$spos * ($barWidth + $Xspacer)"/>
                            <xsl:variable name="numLines" select="count(//line)"/>
                            <!-- making things -->
                            <text x="{$xPosition - ($barWidth div 2)}" y="5" text-anchor="start"
                                style="writing-mode: tb;" font-size="12px">
                                <xsl:apply-templates select="descendant::songTitle"/>
                            </text>
                            <!-- the bar part -->
                            <rect x="{$xPosition - $barWidth}" y="{-($numLines)}" stroke="black"
                                stroke-width=".5" fill="blue" width="{$barWidth}"
                                height="{($numLines)}"/>
                            <!--text to show number -->
                            <text x="{$xPosition - ($barWidth div 2)}" y="{-($numLines)+10}"
                                text-anchor="middle" font-size="12px" fill="white">
                                <xsl:value-of select="$numLines"/>
                            </text>
                        </xsl:for-each>
                    </g>
                </svg>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>
