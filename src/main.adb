with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Semaphores; use GNAT.Semaphores;

procedure Main is
   task type Philosopher is
      entry Start(Id : Integer);
   end Philosopher;

   Forks : array (1..5) of Counting_Semaphore(1, Default_Ceiling);

   task body Philosopher is
      Id : Integer;
      Left_Fork, Right_Fork : Integer;
   begin
      accept Start (Id : in Integer) do
         Philosopher.Id := Id;
      end Start;
      Left_Fork := Id;
      Right_Fork := (Id mod 5) + 1;

      for I in 1..10 loop
         Put_Line("Philosopher " & Id'Img & " is thinking for the " & I'Img & "th time");
         delay 1.0;
         if Id mod 2 = 0 then
            Forks(Left_Fork).Seize;
            Put_Line("Philosopher " & Id'Img & " picked up left fork " & Left_Fork'Img);
            Forks(Right_Fork).Seize;
            Put_Line("Philosopher " & Id'Img & " picked up right fork " & Right_Fork'Img);
         else
            Forks(Right_Fork).Seize;
            Put_Line("Philosopher " & Id'Img & " picked up right fork " & Right_Fork'Img);
            Forks(Left_Fork).Seize;
            Put_Line("Philosopher " & Id'Img & " picked up left fork " & Left_Fork'Img);
         end if;

         Put_Line("Philosopher " & Id'Img & " is eating for the " & I'Img & "th time");
         delay 1.0;
         Forks(Left_Fork).Release;
         Put_Line("Philosopher " & Id'Img & " put down left fork " & Left_Fork'Img);
         Forks(Right_Fork).Release;
         Put_Line("Philosopher " & Id'Img & " put down right fork " & Right_Fork'Img);
      end loop;
      Put_Line("Philosopher " & Id'Img & " leaving.");
   end Philosopher;

   Philosophers : array (1..5) of Philosopher;
Begin
   for I in Philosophers'Range loop
      Philosophers(I).Start(I);
   end loop;

end Main;
