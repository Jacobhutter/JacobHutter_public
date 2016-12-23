#include "RealNumber.h"
// this program provides all the functionality for real numbers, making the class, implementing it and also defining the operations +-*/, this code is written by 
//jacob hutter and will work with a wide array of different types of operator inputs as well as operands.
//to_String converts real and imaginary components to string of type a+bi
string RealNumber::to_String(void){
	stringstream my_output;
	my_output << value;
	return my_output.str();
}
//Empty Constructor		
		RealNumber::RealNumber(){
		NumberType = REAL;
		value = 0;
		return;
}
		//Complete Constructor
		RealNumber::RealNumber(double rval){
		NumberType = REAL;
		value = rval;
		return;
}

		//Setter and getter functions
		void RealNumber::set_value(double rval){
			value = rval;
}
		double RealNumber::get_value(void) const{
		return value;
}

		//Class member functions
		double RealNumber::magnitude(){
		return abs(value);
}

		//Operation overload for RealNumber (op) RealNumber
		RealNumber RealNumber::operator + (const RealNumber& arg){
			return RealNumber(value + arg.value);
   }
		RealNumber RealNumber::operator - (const RealNumber& arg){
			return RealNumber(value - arg.value);
   }
		RealNumber RealNumber::operator * (const RealNumber& arg){
			return RealNumber(value * arg.value);
   }
		RealNumber RealNumber::operator / (const RealNumber& arg){
			return RealNumber(value / arg.value);
   }

		//Operation overload for RealNumber (op) ComplexNumber
		ComplexNumber RealNumber::operator + (const ComplexNumber& arg){
			return ComplexNumber::ComplexNumber(value + arg.get_realComponent(),arg.get_imagComponent());
 	}
		ComplexNumber RealNumber::operator - (const ComplexNumber& arg){
			return ComplexNumber::ComplexNumber(value - arg.get_realComponent(),-arg.get_imagComponent());
	}
		ComplexNumber RealNumber::operator * (const ComplexNumber& arg){
			return ComplexNumber::ComplexNumber(value * arg.get_realComponent(),value * arg.get_imagComponent());
	}
		ComplexNumber RealNumber::operator / (const ComplexNumber& arg){
			double conjugate = -arg.get_imagComponent();
			double real = value * arg.get_realComponent();
			double imag = value * conjugate;
			double den = 0;
			den += arg.get_realComponent() * arg.get_realComponent();
			den += -(arg.get_imagComponent() * conjugate);
			real = real/den;
			imag = imag/den;
			return ComplexNumber::ComplexNumber(real,imag);
	}

		//Operation overload for RealNumber (op) RationalNumber
		RealNumber RealNumber::operator + (const RationalNumber& arg){
		double numer = arg.get_numerator();
		double deno = arg.get_denominator();
		numer = numer/deno;
		return RealNumber(value + numer);
  }
		RealNumber RealNumber::operator - (const RationalNumber& arg){
		double numer = arg.get_numerator();
		double deno = arg.get_denominator();
		numer = numer/deno;
		return RealNumber(value - numer);
	}
		RealNumber RealNumber::operator * (const RationalNumber& arg){
		double numer = arg.get_numerator();
		double deno = arg.get_denominator();
		numer = numer/deno;
		return RealNumber(value * numer);
	}
		RealNumber RealNumber::operator / (const RationalNumber& arg){
		double numer = arg.get_numerator();
		double deno = arg.get_denominator();
		numer = numer/deno;
		return RealNumber(value / numer);
  }
