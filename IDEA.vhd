------------IDEA 16 bit Data Encription----------
----------------------Coded by Salah-------------
-------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;
  use ieee.numeric_std.all;

entity IDEA is
  port( Data: in std_logic_vector(0 to 15);
        Key: in std_logic_vector(0 to 31);
        Mode: in std_logic;
        Output:out std_logic_vector(0 to 15));
end IDEA;
 
architecture Operation of IDEA is
  type r is array(0 to 4,0 to 5) of std_logic_vector(0 to 3);
  type dr is array(0 to 13) of std_logic_vector(0 to 3);

  begin
    
    process(Data,Key,Mode)
      variable Round,TempRound:r;
      variable InData,OutData:std_logic_vector(0 to 15);
      variable InKey:std_logic_vector(0 to 31);
      variable j,k,l,n:integer;
      variable temp:std_logic;
      variable DataKey:dr;
      
      function ExclusiveOr( a:std_logic_vector(0 to 3);
                            b:std_logic_vector(0 to 3))
                            return std_logic_vector is
        variable ReturnValue:std_logic_vector(0 to 3);
        variable c:std_logic_vector(0 to 3);
        begin
          
          ReturnValue:=a xor b;
          
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
      begin
        
        if(Mode='1')then--Encription
          
          --initialising variables
          for i in 0 to 4 loop
            for j in 0 to 5 loop
              Round(i,j):="0000";
            end loop;
          end loop; 
          InData:=Data;--data to variable
          InKey:=Key;--key to variable
        
          --creating the Look Up Table
        
          j:=0;
          k:=0;
          l:=0;
          while(k<5)loop
          
            exit when(k=4 and l=4);
          
            if(l=6)then
              l:=0;
              k:=k+1;
            end if;
              
            Round(k,l):=InKey(j to (j+3));
            l:=l+1;
            j:=j+4;
          
            if(j=32)then
              j:=0;
              --Shifting of InKey should be done here
              for i in 0 to 5 loop
                temp:=InKey(0);
                for m in 0 to 30 loop
                  InKey(m):=InKey(m+1);
                end loop;
                InKey(31):=temp;
              end loop;
              --shifting over
            
            end if;
          end loop;
          --Look Up Table is now created
          
          
          --The Encription starts from here using the look up table
          --convert every function return value to std_logic_vector(size(4))
          for index in 0 to 3 loop

            DataKey(0):=Multiplication(Round(index,0),InData(0 to 3));--0
            DataKey(1):=Addition(Round(index,1),InData(4 to 7));--1
            DataKey(2):=Addition(Round(index,2),InData(8 to 11));--2
            DataKey(3):=Multiplication(Round(index,3),InData(12 to 15));--3

            DataKey(4):=ExclusiveOr(DataKey(0),DataKey(2));--4
            DataKey(5):=ExclusiveOr(DataKey(1),DataKey(3));--5
            
            DataKey(6):=Multiplication(Round(index,4),DataKey(4));--6
            DataKey(7):=Addition(DataKey(6),DataKey(5));--7
            DataKey(8):=Multiplication(Round(index,5),DataKey(7));--9
            DataKey(9):=Addition(DataKey(6),DataKey(8));--8
          
            --intermediate data will be here
            DataKey(10):=ExclusiveOr(DataKey(8),DataKey(0));--10
            DataKey(11):=ExclusiveOr(DataKey(9),DataKey(1));--11
            DataKey(12):=ExclusiveOr(DataKey(8),DataKey(2));--12
            DataKey(13):=ExclusiveOr(DataKey(9),DataKey(3));--13

            --assigning current data to variable for further use
            InData(0 to 3):=DataKey(10);
            InData(4 to 7):=DataKey(11);
            InData(8 to 11):=DataKey(12);
            InData(12 to 15):=DataKey(13);

          end loop;
          --end of first four Round
          
          --last Round

          DataKey(0):=Multiplication(Round(4,0),InData(0 to 3));
          DataKey(2):=Addition(Round(4,2),InData(8 to 11));
          DataKey(1):=Addition(Round(4,1),InData(4 to 7));
          DataKey(3):=Multiplication(Round(4,3),InData(12 to 15));
          
          --assigning current data to variable for further use
          InData(0 to 3):=DataKey(0);
          InData(4 to 7):=DataKey(1);
          InData(8 to 11):=DataKey(2);
          InData(12 to 15):=DataKey(3);
       
          --Encripted 16 bit Data is now available :)
          OutData:=InData;
          --Encription Over ;)
        elsif(Mode='0')then--decription
          
                    
          --initialising variables
          for i in 0 to 4 loop
            for j in 0 to 5 loop
              Round(i,j):="0000";
            end loop;
          end loop; 
          InData:=Data;--data to variable
          InKey:=Key;--key to variable
          
          --creating the Look Up Table
        
          j:=0;
          k:=0;
          l:=0;
          while(k<5)loop
          
            exit when(k=4 and l=4);
          
            if(l=6)then
              l:=0;
              k:=k+1;
            end if;
              
            Round(k,l):=InKey(j to (j+3));
            l:=l+1;
            j:=j+4;
          
            if(j=32)then
              j:=0;
              --Shifting of InKey should be done here
              for i in 0 to 5 loop
                temp:=InKey(0);
                for m in 0 to 30 loop
                  InKey(m):=InKey(m+1);
                end loop;
                InKey(31):=temp;
              end loop;
              --shifting over
            
            end if;
          end loop;
          
          --Look up table for decription
          
          j:=4;
          k:=0;
          --for tracking Round(Look Up Table)
          l:=0;
          n:=0;
          while(j<5)loop
            
            --action
            if(k=0 or k=3)then
              TempRound(j,k):=InverseMultiplication(Round(l,n));
            elsif(k=1 or k=2)then
              TempRound(j,k):=InverseAddition(Round(l,n));
            elsif(k=4 or k=5)then
              TempRound(j,k):=Round(l,n);
            end if;
            
            --leading the loop
            n:=n+1;
            if(n=6)then
              n:=0;
              l:=l+1;
            end if;
            
            k:=k+1;
            if(k=4)then
              j:=j-1;
            elsif(k=6)then
              k:=0;
            end if;
            
            exit when(l=4 and n=4);
            
          end loop;
          
          Round:=TempRound;
          --Look Up Table is now created
          
          
          --The Decription starts from here using the look up table
          --convert every function return value to std_logic_vector(size(4))
          for index in 0 to 3 loop

            DataKey(0):=Multiplication(Round(index,0),InData(0 to 3));--0
            DataKey(1):=Addition(Round(index,1),InData(4 to 7));--1
            DataKey(2):=Addition(Round(index,2),InData(8 to 11));--2
            DataKey(3):=Multiplication(Round(index,3),InData(12 to 15));--3

            DataKey(4):=ExclusiveOr(DataKey(0),DataKey(2));--4
            DataKey(5):=ExclusiveOr(DataKey(1),DataKey(3));--5            
            DataKey(6):=Multiplication(Round(index,4),DataKey(4));--6
            DataKey(7):=Addition(DataKey(6),DataKey(5));--7
            DataKey(8):=Multiplication(Round(index,5),DataKey(7));--9
            DataKey(9):=Addition(DataKey(6),DataKey(8));--8
          
            --intermediate data will be here
            DataKey(10):=ExclusiveOr(DataKey(8),DataKey(0));--10
            DataKey(11):=ExclusiveOr(DataKey(9),DataKey(1));--11
            DataKey(12):=ExclusiveOr(DataKey(8),DataKey(2));--12
            DataKey(13):=ExclusiveOr(DataKey(9),DataKey(3));--13

            --assigning current data to variable for further use
            InData(0 to 3):=DataKey(10);
            InData(4 to 7):=DataKey(11);
            InData(8 to 11):=DataKey(12);
            InData(12 to 15):=DataKey(13);

          end loop;
          --end of first four Round
          
          --last Round

          DataKey(0):=Multiplication(Round(4,0),InData(0 to 3));
          DataKey(2):=Addition(Round(4,2),InData(8 to 11));
          DataKey(1):=Addition(Round(4,1),InData(4 to 7));
          DataKey(3):=Multiplication(Round(4,3),InData(12 to 15));
          
          --assigning current data to variable for further use
          InData(0 to 3):=DataKey(0);
          InData(4 to 7):=DataKey(1);
          InData(8 to 11):=DataKey(2);
          InData(12 to 15):=DataKey(3);
          --Decripted 16 bit Data is now available :)
          OutData:=InData;
          --Decription Over ;)
          
        end if;
        
        --output
        Output<=OutData;    
    end process;
    
end Operation;

-----------------------------------------------------------------
