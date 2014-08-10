



#define NUMBER_OF_PROCESSES 3

int array[NUMBER_OF_PROCESSES];
bool arrayInitialized = false


bool WantCriticalSection[NUMBER_OF_PROCESSES]
bool IsCriticalBusy = false


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
		if
			:: IsCriticalBusy -> goto WaitForCriticalSection
			:: else -> IsCriticalBusy = true
		fi
		
	CriticalSection:
		if
		::
			int j = 0;
			int temp = array[_pid];
			array[_pid] = array[j];
			array[j] = temp;
			
			IsCriticalBusy = false
		fi
}






