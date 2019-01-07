#include "ComplexNumber.h"
// this program provides all the functionality for complex numbers, making the class, implementing it and also defining the operations +-*/, this code is written by 
//jacob hutter and will work with a wide array of different types of operator inputs as well as operands.
//to_String converts real and imaginary components to string of type a+bi
string ComplexNumber::to_String(void){
	stringstream my_output;
	my_output << realComponent;
	if(imagComponent >= 0){
		my_output << " + " << imagComponent << "i";
	}
	else if(imagComponent < 0){
		my_output << "-" << imagComponent*(-1) << "i";
	}
	return my_output.str();
}

ComplexNumber::ComplexNumber(){
		NumberType = COMPLEX;
	  realComponent = 0;
		imagComponent = 0;
		return;
}
ComplexNumber::ComplexNumber(double real, double imag){
	 NumberType = COMPLEX;
	 realComponent = real;
	 imagComponent = imag;
	return;
}
void ComplexNumber::set_realComponent(double rval){
	realComponent = rval;
	return;
}
void ComplexNumber::set_imagComponent(double ival){
	imagComponent = ival;
	return;
}
		double ComplexNumber::get_realComponent(void) const{
		return realComponent;
}
		double ComplexNumber::get_imagComponent(void) const{
		return imagComponent;
}
		void   ComplexNumber::set_value (double rval, double ival){
						realComponent = rval;
						imagComponent = ival;
						return;
}

		//Class member functions
		double ComplexNumber::magnitude(){
		return abs(imagComponent)+abs(imagComponent);
}

		//Operation overload for ComplexNumber (op) ComplexNumber
		ComplexNumber ComplexNumber::operator + (const ComplexNumber& arg){
		double real = realComponent + arg.get_realComponent();
		double imag = imagComponent + arg.get_imagComponent();
		return ComplexNumber(real,imag);
		
}
		ComplexNumber ComplexNumber::operator - (const ComplexNumber& arg){
		double real = realComponent - arg.get_realComponent();
		double imag = imagComponent - arg.get_imagComponent();
		return ComplexNumber(real,imag);
}
		ComplexNumber ComplexNumber::operator * (const ComplexNumber& arg){
		double real = (realComponent * arg.get_realComponent()) - (imagComponent * arg.get_imagComponent());
		double imag = (realComponent * arg.get_imagComponent()) + (imagComponent * arg.get_realComponent());
		return ComplexNumber(real,imag);
}
		ComplexNumber ComplexNumber::operator / (const ComplexNumber& arg){
		double conjugatei = -arg.get_imagComponent();
		double real = 0;
		real += arg.get_realComponent()*realComponent;
		real +=  -(imagComponent * conjugatei);
		double imag = 0;
		imag += conjugatei*realComponent;
		imag += imagComponent * arg.get_realComponent();
		double den = 0;
		den += arg.get_realComponent() * arg.get_realComponent();
		den += -(arg.get_imagComponent() * conjugatei);
		real = real/den;
		if(real == -0)
			real =0;
		imag = imag/den;
		return ComplexNumber(real,imag);
			
}

		//Operation overload for ComplexNumber (op) RealNumber		
		ComplexNumber ComplexNumber::operator + (const RealNumber& arg){
		double real = realComponent + arg.get_value();
		double imag = imagComponent;
		return ComplexNumber(real,imag);
}
		ComplexNumber ComplexNumber::operator - (const RealNumber& arg){
		double real = realComponent - arg.get_value();
		double imag = imagComponent;
		return ComplexNumber(real,imag);
}
		ComplexNumber ComplexNumber::operator * (const RealNumber& arg){
		double real = realComponent * arg.get_value();
		double imag = imagComponent * arg.get_value();
		return ComplexNumber(real,imag);
}
		ComplexNumber ComplexNumber::operator / (const RealNumber& arg){
		double real = realComponent / arg.get_value();
		double imag = imagComponent / arg.get_value();
		return ComplexNumber(real,imag);
}

		//Operation overload for ComplexNumber (op) RationalNumber	
		ComplexNumber ComplexNumber::operator + (const RationalNumber& arg){
		double numer = arg.get_numerator(); // to improve accuracy
		double deno = arg.get_denominator();
		numer = numer/deno;
		double real = realComponent + numer;
		double imag = imagComponent;
		return ComplexNumber(real,imag);
}
		ComplexNumber ComplexNumber::operator - (const RationalNumber& arg){
		double numer = arg.get_numerator(); // to improve accuracy
		double deno = arg.get_denominator();
		numer = numer/deno;
		double real = realComponent - numer;
		double imag = imagComponent;
		return ComplexNumber(real,imag);
}
		ComplexNumber ComplexNumber::operator * (const RationalNumber& arg){
		double numer = arg.get_numerator(); // to improve accuracy
		double deno = arg.get_denominator();
		numer = numer/deno;
		double real = realComponent * numer;
		double imag = imagComponent * numer;
		return ComplexNumber(real,imag);
}
		ComplexNumber ComplexNumber::operator / (const RationalNumber& arg){
		double numer = arg.get_numerator(); // to improve accuracy
		double deno = arg.get_denominator();
		numer = numer/deno;
		double real = realComponent / numer;
		double imag = imagComponent / numer;
		return ComplexNumber(real,imag);
}