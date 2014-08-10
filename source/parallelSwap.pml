



#define NUMBER_OF_PROCESSES 3

#define ARRAY_SIZE 10

int array[ARRAY_SIZE];
bool arrayInitialized = false



active [NUMBER_OF_PROCESSES] proctype ParallelSwap()
{
	printf("Process %d\n", _pid); 
	
	if 
		:: (_pid == 0) ->
			int count = 0;
			do
			:: ((count) >= ARRAY_SIZE) -> 
				arrayInitialized = true;
				break;
			:: else ->
				array[count] = count;
				count++;
			od;
		:: else -> skip;
	fi
	
	wait: 
		if
			:: !arrayInitialized -> 
				goto wait;
			:: else -> skip;
		fi
	
	assert(array[9] == 9)
}






