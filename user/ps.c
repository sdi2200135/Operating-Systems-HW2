#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/pstat.h"
#include "user/user.h"

int main(void){
    struct pstat ps;

    if(getpinfo(&ps) < 0){  //κλήση της νέας syscall getpinfo()
        printf("Error: getinfo failed\n");
        exit(1);
    }

    printf("PID\tPPID\tPRIOR\tSTATE\t\tSIZE\tNAME\n");

    for(int i=0; i<NPROC; i++){
        if(ps.isused[i]){   //φιλτράρουμε μόνο τις χρησιμοποιούμενες διεργασίες και αν βγαλω το if βγαζει και καποια unused και καποια used αλλα μετα γίνεται ο χαμός
            char* state_str;
            switch(ps.pstate[i]){   //μετατροπή αριθμητικής κατάστασης σε string
                case 0: state_str = "UNUSED   "; break;
                case 1: state_str = "USED     "; break;
                case 2: state_str = "SLEEPING "; break;
                case 3: state_str = "RUNNABLE "; break;
                case 4: state_str = "RUNNING  "; break;
                case 5: state_str = "ZOMBIE   "; break;
                default: state_str = "???      ";
            }

            //εκτύπωση όλων των πληροφοριών που μας δίνει το pstat
            printf("%d\t%d\t%d\t%s\t%d\t%s\n", ps.pid[i], ps.ppid[i], ps.priority[i], state_str, ps.memsize[i], ps.pname[i]);
        }
    }

    exit(0);
}