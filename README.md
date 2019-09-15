====================================================
Name:         d2lfg.sh
Version:      1.1.0
Author:       Mario Rybar
E-Mail:       majlo.rybar@gmail.com
Date:         08.09.2019
====================================================
# CHANGE LOG:
  08.09.2019 - Initial version
  15.09.2019 - v1.1.0: optimalization

========================================================================================================
# PREPARATIONS:
  1. make both files executable
  2. Start ./init_d2lfg.sh [REFRESH INTERVAL] [GAME TYPE] [FILTER]
  3. Stop ctrl+c

# USAGE:
  ./init_d2lfg.sh [REFRESH INTERVAL] [GAME TYPE] [FILTER]

# INPUT PARAMETERS:
  [REFRESH INTERVAL]: number in seconds
         [GAME TYPE]: raid, crucible, nightfall, gambit, blindwell, escalationprotocol, reckoning, menagerie
            [FILTER]: key1,key2,prestige,catalyst   *optional parameter

# EXAMPLE:
  ./init_d2lfg.sh 30 crucible pvp,luna,comp

========================================================================================================
# DESCRIPTION:
  - Init script is used to call main script in `watch` command:
    $ watch -n <refresh interval> -ct './d2lfg.sh'

  - Main script is called by init_d2lfg.sh due to watch command limitations.
  - Input parameters/variables can not be passed to watch, tmp file is created instead.
  - Tmp file is removed when watch stops.
  - Init checks dependencies and log results.
  - Main output is shown with automatic refresh according to input paramter.
  - To STOP watch press ctrl+c

========================================================================================================
# NAMING CONVENTION:
  lfg-v1.0.0.sh
  scriptname-v[Major change].[Minor change].[revision].sh

========================================================================================================
