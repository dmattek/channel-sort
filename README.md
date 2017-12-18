Script name      : `chsort.sh`

Author           : Maciej Dobrzynski

Date created     : 20171243

Purpose          : Process files in the specified directory and move them to
				  folders based on the filename.

**Example usage:**
Assume we have a directory *~/test* with files: 
    RhoA2G_LA_1s_01_w26TIRFFRETacceptor_t75.TIF,
    RhoA2G_LA_1s_01_w16TIRF CFP_t67.TIF
    etc.

Executing *./chsort ~/test* will put these files into subfolders:
   RhoA2G_LA_1s_01/w26TIRFFRETacceptor/RhoA2G_LA_1s_01_w26TIRFFRETacceptor_t75.TIF
   RhoA2G_LA_1s_01/w16TIRF-CFP/RhoA2G_LA_1s_01_w16TIRF CFP_t67.TIF
  
Note, spaces in subfolders will be replaced by dashes.
 
Reg-ex pattern for extracting folder names from the filename defined by variable *regex*.
 
**WARNING**: uses GNU getopt
Standard OSX installation of getopt doesn't support long params
Install through macports
sudo port install getopt

Tested on:
OSX 10.11.6 (Darwin Kernel Version 15.6.0)
Ubuntu 16.04.2 LTS
