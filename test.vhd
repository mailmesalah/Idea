library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;
  
entity test is
  port( --in1,in2: in std_logic_vector(0 to 3);
        --in3:in bit_vector(0 to 3);
        --x:in std_logic;
        --Key: in std_logic_vector(0 to 31);
        --Mode: in std_logic;
        a:in string(1 to 10);
        b:in integer;
        c:out std_logic_vector(0 to 9));
        --Output:out std_logic_vector(0 to 3));
end test;

architecture Operation of test is

begin
  process(a,b)--in1,in2,x)
    
function stdLogicToBitVector( a:std_logic_vector;
                      b:integer)
      return bit_vector is
    variable ReturnValue:bit_vector(0 to b-1);
    begin

    for i in 0 to b-1 loop
      if(a(i)='1')then
        ReturnValue(i):='1';
      elsif(a(i)='0')then
        ReturnValue(i):='0';
      end if;
    end loop;
    
  return ReturnValue;
end stdLogicToBitVector;    
    
function ExclusiveOr( a:std_logic_vector(0 to 3);
                      b:std_logic_vector(0 to 3))
      return integer is
    variable ReturnValue:integer;
    variable c:std_logic_vector(0 to 3);
    begin
          
    c:=a xor b;
    ReturnValue:=conv_integer(c);
          
  return ReturnValue;
end ExclusiveOr;


function Addition( a:std_logic_vector(0 to 3);
                      b:std_logic_vector(0 to 3))
                      return std_logic_vector is
  variable x,y,z:integer;
  variable ReturnValue :std_logic_vector(0 to 3);
  begin
    
    x:=conv_integer(a);
    y:=conv_integer(b);
    z:=x+y;
    if(z>15)then
      z:=z-16;
    end if;
    ReturnValue:=conv_std_logic_vector(z,4);
    
    return ReturnValue;
end Addition;
function Multiplication( a:std_logic_vector(0 to 3);
                         b:std_logic_vector(0 to 3))
                         return std_logic_vector is
     variable x,y,z:integer; 
     variable ReturnValue:std_logic_vector(0 to 3);
     begin
       
       x:=conv_integer(a);
       y:=conv_integer(b);
       z:=x*y;
       z:=z mod 17;
       if(y=0)then
         z:=17-x;
       end if;
       
       ReturnValue:=conv_std_logic_vector(z,4);

       
       return ReturnValue;
   end Multiplication;
   
      function InverseAddition( a:std_logic_vector(0 to 3))
                            return std_logic_vector is
        variable x,z:integer;
        variable ReturnValue:std_logic_vector(0 to 3); 
        begin
          
          x:=conv_integer(a);
          
          z:=16-x;
          if(z>15)then
            z:=16-z;
          end if;
          ReturnValue:=conv_std_logic_vector(z,4);
          
          return ReturnValue;
      end InverseAddition;
      function InverseMultiplication( a:std_logic_vector(0 to 3))
                            return std_logic_vector is
        variable ReturnValue:std_logic_vector(0 to 3); 
        begin
          
          case a is
            when "0000" =>ReturnValue:="0000";
            when "0001" =>ReturnValue:="0001";
            when "0010" =>ReturnValue:="1001";
            when "0011" =>ReturnValue:="0110";
            when "0100" =>ReturnValue:="1101";
            when "0101" =>ReturnValue:="0111";
            when "0110" =>ReturnValue:="0011";
            when "0111" =>ReturnValue:="0101";
            when "1000" =>ReturnValue:="1111";
            when "1001" =>ReturnValue:="0010";
            when "1010" =>ReturnValue:="1100";
            when "1011" =>ReturnValue:="1110";
            when "1100" =>ReturnValue:="1010";
            when "1101" =>ReturnValue:="0100";
            when "1110" =>ReturnValue:="1011";
            when "1111" =>ReturnValue:="1000";
            when others =>null;
          end case;

          return ReturnValue;
      end InverseMultiplication;
      
    function StringToStdLogic( a:string;b:integer)
                            return std_logic_vector is
    --Function to convert String to std_logic_vector
    --only zero and one is converted
      
      variable x:std_logic_vector(0 to b-1);
      variable ReturnValue:std_logic_vector(0 to b-1); 
      
      begin
          
        for i in 1 to b loop
          case a(i) is
            when '0'=> x(i-1):='0';
            when '1'=> x(i-1):='1';
            when others =>null;
          end case ;
        end loop ;         
        
        ReturnValue:=x;
          
        return ReturnValue;
    end StringToStdLogic;
      
      --variable n:std_logic_vector(0 to 9):="XXXXXXXXXX";
    begin
  
    --Output<=conv_std_logic_vector(Multiplication(in1,in2),4);    
      --Output<=InverseMultiplication(in1);
      --Output<=Multiplication(in1 , in2);
    --case x is
      --when  '0' =>Output<=InverseMultiplication(in1);
      --when  '1' =>Output<=InverseAddition(in1);
      --when others=>null;
    --end case;
      --Output<=InverseMultiplication(in1);
      c(0 to (b-1))<=StringToStdLogic(a,b);
  end process;
  
   
end Operation;