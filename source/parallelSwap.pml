



#define NUMBER_OF_PROCESSES 3

#define ARRAY_SIZE 10

int array[ARRAY_SIZE];
bool arrayInitialized = false



active [NUMBER_OF_PROCESSES] proctype P1()
{
	printf("Process %d\n", _pid); 
	
	if 
		:: _pid == 0 ->
			int count = 0
			do
			::
				printf("count %d\n", count)
				array[count] = count
				count = count + 1
				
				if
					:: (count >= ARRAY_SIZE) -> 
						printf("ending do loop\n")
						arrayInitialized = true
						break
				fi
			od
			
			printf("ended do loop\n")
		:: else -> printf("not initializing array in this process\n")
	fi
	
}






