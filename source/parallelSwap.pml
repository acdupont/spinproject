


#define NUMBER_OF_PROCESSES 3

int array[NUMBER_OF_PROCESSES];
int array_original[NUMBER_OF_PROCESSES];
bool arrayInitialized = false


int numberOfProcessesInCritical = 0
int numberOfCompletedProcesses = 0



active [NUMBER_OF_PROCESSES] proctype ParallelSwap()
{
	//initialize array with distinct values
	if 
		:: (_pid == 0) ->
			int index = 0
			do
			:: index > (NUMBER_OF_PROCESSES - 1) -> 
				arrayInitialized = true;
				break
			:: else ->
				array[index] = index;
				array_original[index] = index
				index++
			od
			
		:: else -> skip;
	fi
	
	//all processes need to wait until array is initialized
	WaitForInitialization: 
		if
			:: arrayInitialized -> skip
			:: else -> goto WaitForInitialization;
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
			numberOfCompletedProcesses++
		fi
	
	WaitForFinish:
		if 
			:: (numberOfCompletedProcesses == NUMBER_OF_PROCESSES) -> skip;
			:: else -> goto WaitForFinish;
		fi
	
	
	//make sure the same values are contained by the original array and the new array
	bool hasSameValues = true
	int index_original = 0 
	do 
	:: index_original > (NUMBER_OF_PROCESSES - 1) -> break
	:: else -> 
		int index_new = 0
		bool hasCurrentValue = false
		do
		:: index_new > (NUMBER_OF_PROCESSES - 1) -> break
		:: else ->
			if
				:: array_original[index_original] == array[index_new] -> 
					hasCurrentValue = true
					break
				:: else -> skip
			fi
			
			index_new++
		od
		
		index_original++
		
		if 
			:: !hasCurrentValue -> 
				hasSameValues = false;
				break;
			:: else -> skip;
		fi
	od
	
	assert(hasSameValues)
	
	
	//make sure the arrays are not ordered the same (we are assuming they won't end up the same)
	bool hasDifferentOrder = false
	index_original = 0 
	do 
	:: index_original > (NUMBER_OF_PROCESSES - 1) -> break
	:: else -> 
		if 
			:: array_original[index_original] != array[index_original] ->
				hasDifferentOrder = true
				break;
			:: else -> skip;
		fi
	od
	
	assert(hasDifferentOrder)
}




//ltl safety { [] (numberOfProcessesInCritical < 2) }
ltl complete { <> (numberOfCompletedProcesses == NUMBER_OF_PROCESSES) }
//ltl complete { (<> [] np_) }


