



#define NUMBER_OF_PROCESSES 3

int array[NUMBER_OF_PROCESSES];
bool arrayInitialized = false


bool WantCriticalSection[NUMBER_OF_PROCESSES]
int numberOfProcessesInCritical = 0


active [NUMBER_OF_PROCESSES] proctype ParallelSwap()
{
	//initialize array with distinct values
	if 
		:: (_pid == 0) ->
			int count = 0;
			do
			:: ((count) >= NUMBER_OF_PROCESSES) -> 
				arrayInitialized = true;
				break;
			:: else ->
				array[count] = count;
				count++;
			od;
		:: else -> skip;
	fi
	
	//all processes need to wait until array is initialized
	WaitForInitialization: 
		if
			:: !arrayInitialized -> goto WaitForInitialization;
			:: else -> skip;
		fi
	
	
	WaitForCriticalSection:
		atomic
		{
			if
				:: (numberOfProcessesInCritical > 0) -> goto WaitForCriticalSection
				:: else -> numberOfProcessesInCritical++
			fi
		}
		
	CriticalSection:
		if
		::
			//not sure how to "randomly" choose a j here
			int j = 0;
			int temp = array[_pid];
			array[_pid] = array[j];
			array[j] = temp;
			
			numberOfProcessesInCritical--
		fi
}




//#define pInCS (P@CS)
//#define qInCS (Q@CS)

//#define pTrying (P@TS)
//#define qTrying (Q@TS)


//#define mutex (!(pInCS && qInCS))
//#define progress4P (pTrying -> <> pInCS)
//#define progress4Q (qTrying -> <> qInCS)

ltl safety { [] (numberOfProcessesInCritical < 2) }
//ltl progP { [] progress4P }
//ltl progQ { [] progress4Q }


