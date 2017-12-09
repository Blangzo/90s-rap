<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="xs math"
    xmlns="http://www.w3.org/2000/svg" version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- global vars -->
    <xsl:variable name="songColl" select="collection('markedup_songs')"/>
    <xsl:variable name="numSongs" select="count($songColl//song)"/>
    <xsl:variable name="lineMax"
        select="
            max(for $file in $songColl//song
            return
                count($file//line))"/>
    <xsl:variable name="temp2" select="$songColl//song[count(//line) eq $lineMax]"/>
    <xsl:variable name="Xinterval" select="100"/>
    <!--<xsl:variable name="width" select="$numSongs * ($Xinterval + 1) + 500"/>
    <xsl:variable name="height" select="$lineMax div 10 * $Yinterval + 300"/>-->
    <!-- start -->
    <xsl:template match="/">
        <xsl:comment><xsl:value-of select="$lineMax"/></xsl:comment>
        <xsl:comment>linemax file: <xsl:apply-templates select="$temp2//songTitle"/></xsl:comment>
        <svg xmlns="http://www.w3.org/2000/svg" width="{5000}" height="{400}"
            viewBox="0 0 {5000} {400}">
            <g transform="translate(50 {160})">
                <text x="90" y="{-$lineMax - 20}" fill="red">Line graph of the count of lines in
                    each of the songs.</text>
                <!--X axis: -->
                <line x1="0" y1="0" x2="{$numSongs * ($Xinterval+1)}" y2="0" stroke-width="3"
                    stroke="black"/>
                <!--Y axis: -->
                <line x1="0" y1="0" x2="0" y2="{-$lineMax - 10}" stroke-width="3" stroke="black"/>
                <!--Y axis hashmarks and hashlines -->
                <xsl:for-each select="1 to xs:integer($lineMax)">
                    <xsl:if test=". mod 20 = 0">
                        <xsl:variable name="HashLocator" select="."/>
                        <xsl:variable name="HashLabel" select="."/>
                        <text x="-5" y="{-$HashLocator}" fill="red" text-anchor="end">
                            <xsl:value-of select="."/>
                        </text>
                        <line x1="0" y1="{-.}" x2="{$numSongs * ($Xinterval+1)}" y2="{-.}"
                            stroke="red" stroke-width=".5" stroke-dasharray="30"/>
                    </xsl:if>
                </xsl:for-each>

                <xsl:for-each select="$songColl//song">
                    <xsl:variable name="Pos" select="position()"/>
                    <xsl:variable name="xPos" select="$Pos * $Xinterval - $Xinterval div 2"/>
                    <!-- X axis labels: -->
                    <text x="{$xPos}" y="15" fill="red" text-anchor="beginning"
                        transform="rotate(50 {$xPos} 25)">
                        <xsl:apply-templates select="//songTitle"/>
                    </text>
                    <xsl:variable name="color">
                        <xsl:choose>
                            <xsl:when test="//artist = '2Pac'">Black</xsl:when>
                            <xsl:when test="//artist = 'Eminem'">Red</xsl:when>
                            <xsl:otherwise>Yellow</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <rect width="50" height="{count(//line)}" x="{$xPos}" y="{-count(//line)}"
                        stroke="black" stroke-width=".5" fill="{$color}"/>
                    <xsl:comment><xsl:apply-templates select="-count(//line)"/></xsl:comment>
                    <!--<xsl:if test="$Pos ne last()">
                        <line x1="{$Pos * $Xinterval - $Xinterval div 2}"
                            y1="{count(descendant::app) * $Yinterval}"
                            x2="{($Pos + 1) * $Xinterval - $Xinterval div 2}"
                            y2="{count($songColl//song[descendant::title = current()//idno + 1]//app) * $Yinterval}"
                            stroke-width="2" stroke="green"/>
                    </xsl:if>-->
                </xsl:for-each>
            </g>
        </svg>
    </xsl:template>
</xsl:stylesheet>
