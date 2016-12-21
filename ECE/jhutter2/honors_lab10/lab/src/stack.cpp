



std::ostream &operator <<(std::ostream &stream, const Stack &stack)               
{                                                                                 
  size_t idx = 0;                                                                 
  size_t sz = stack.get_size();                                                   
                                                                                  
  // Iterate through the list                                                     
  while (idx < sz)                                                                
  {                                                                               
    stream << stack.at(idx++) << " ";                                             
  }                                                                               
                                                                                  
  return stream;                                                                  
} 

bool Stack::is_empty(){
		bool i = 1;
	size_t j = List::std::get_size():
		if( j>0)
		return !i;
	else return i;


}	
Stack::std::size_t get_size() const{
	size_t size = List::get_size();
	return size;

}

int Stack::peek() const{

}

int Stack::pop(){


}

void Stack::push(int data){


}
