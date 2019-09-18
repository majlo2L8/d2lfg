#  d2lfg.sh 
                       
 **Version:** 1.1.0           
**Author:** Mario Rybar 
**E-Mail:** majlo.rybar@gmail.com         
 **Date:** 08.09.2019. 

 --------------------------------------------------------------------  
### CHANGE LOG  

* v1.0.0 - 08.09.2019 - Initial version  
* v1.1.0 - 15.09.2019 - optimalization     

-------------------------------------------------------------------------------- 
## PREPARATIONS         
       
1. make both files executable         
2. Start `./d2lfg.sh [REFRESH INTERVAL] [GAME TYPE] [FILTER]`              
3. Stop ctrl+c      

------------------------------------------------------------------------------   
## USAGE 
 `sh d2lfg.sh [REFRESH_RATE]... [GAME_TYPE]... [FILTER]... `

### INPUT PARAMETERS  
**Mandatory:**  
 * REFRESH_RATE         
    - number of seconds for results refresh         
        

**Optional:**    
 * GAME_TYPE 
    - name of activity in lower case without spaces   
    - get all activities if parameter does not match activity name   
    - raid crucible nightfall gambit blindwell escalationprotocol reckoning menagerie  

 * FILTER
    - leave empty for disabled filter   
    - search in results for keyword from parameter                    
    - for multiple keywords specify single words without spaces separated by comma   
    - key1,key2,prestige,catalyst,...   
    - -h, --help display this help          
       
### EXAMPLE:                 
 `./d2lfg.sh 30 crucible pvp,luna,comp`    
 
 ---------------------------------------------------------------------------------
## ALTERNATIVE USAGE     

add following line to .bashrc file: `alias lfg='sh /path/d2lfg/d2lfg.sh'`  and call script with simple: `lfg [refresh] [game type] [filter]`        

---------------------------------------------------------------------------------

## DESCRIPTION    

- Init script is used to call main script in `watch` command:  `watch -n -ct './d2lfg-main.sh'`   
- Main script is called by d2lfg.sh due to watch command limitations.  
- Input parameters/variables can not be passed to watch, tmp file is created instead.  
- Tmp file is removed when watch stops.  
- Init checks dependencies and log results.  
- Main output is shown with automatic refresh according to input paramter.  
- To STOP watch press ctrl+c