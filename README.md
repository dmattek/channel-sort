Script name      : `chsort.sh`

Author           : Maciej Dobrzynski

Date created     : 20171243

Last update      : 20190207

Purpose          : Process files in the specified directory and move them to
				  folders based on the filename.

**Example usage:**
Assume we have a directory *~/test* with files: 
    RhoA2G_LA_1s_01_w26TIRFFRETacceptor_t75.TIF,
    RhoA2G_LA_1s_01_w16TIRF CFP_t67.TIF
    etc.

The filenames above contain:

 - experiment name, RhoA2G_LA_1s_01
 - channel name w16TIRF CFP
 - time point, t67
 
"./chsort ~/test" puts these files into subfolders based on experiment name and channel name:
   RhoA2G_LA_1s_01/w26TIRFFRETacceptor/RhoA2G_LA_1s_01_w26TIRFFRETacceptor_t75.TIF
   RhoA2G_LA_1s_01/w16TIRF-CFP/RhoA2G_LA_1s_01_w16TIRF-CFP_t67.TIF
  
Note, spaces in subfolders and file names are replaced by dashes.
 
Reg-ex pattern for extracting folder names from the filename defined by variable *regex*.

After executing chsort.sh, the remaining nd files can be moved to their respective folders 
(based on the filename) using fsort.sh script.
 
**WARNING**: uses GNU getopt
Standard OSX installation of getopt doesn't support long params
Install through macports
sudo port install getopt

Tested on:
OSX 10.11.6 (Darwin Kernel Version 15.6.0)
Ubuntu 16.04.2 LTS
