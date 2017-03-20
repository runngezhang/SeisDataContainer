Data Container for alternative matlab-array clases
(This code was oiginally developed to support more sophisticated
arrays for pSPOT(https://github.com/slimgroup/pSPOT))

You may use this code only under the conditions and terms of the
license contained in the file COPYING.txt provided with this source
code. If you do not agree to these terms you may not use this
software.

Header Bytes and defined as per table 3 in (http://www.seg.org/Portals/0/SEG/News%20and%20Resources/Technical%20Standards/seg_y_rev1.pdf)
Use the starting byte of each sample's range. 
    Example: If I wanted srcX srcY recX recY header information, I would use:
              header_bytes=[73 77 81 85]
