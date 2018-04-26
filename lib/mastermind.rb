# ******** MASTERMIND ********
#The codebreaker should try to guess the pattern, in both order and color, within twelve turns. 
#Each guess is made by choosing 4 characters referring to the colours (B)lue, (G)reen, (O)range, (P)urple, (R)ed, or (Y)ellow.  
#Once the guess is place, the codemaker provides feedback by placing from zero to four 'clues' - 
#   - A TOTAL MATCH is displayed for each code character which is of the correct color AND in the correct position. 
#   - A COLOUR MATCH is displayed for each code character which matches a colour in the code but is not in the correct position.
#
#To play use Mastermind.play
 
  
module Mastermind
 extend self

  def initialize
  end
   
  def play
    puts "Do you want to (G)uess or(C)hoose the secret code?"
    choice = gets.chomp.upcase until choice == "G" || choice == "C"
    choice == "G" ? player_plays : ai_plays
  end

  
  private
         
    def player_plays
      i = 1
      won = false
      puts "\nYou have 12 guesses to identify the A.I's code. A.I. is generating a code.... \n\n"
      code = generate_code
      while i<13 && !won
        print "Your guess was #{guess = get_code("Your Guess", i)}"
        won = true if match?(code, guess)
        i += 1
      end
      puts "You ran out of guesses!" if i ==13
    end

    def ai_plays
      i = 1
      won = false
      guess = ["B","G","O","P"] # First guess
      all_code_optns = [*1..6].repeated_permutation(4).to_a.collect{|x| x = num_to_letter(x)} #1296 item array of possible answers 
      code = get_code("\nChoose your code for the A.I. to guess!")
      puts "\nYou chose #{code}\n\n"
        
      while i<13 && !won
        print "A.I.'s' guess \##{i} was #{guess}"
        won = true if match?(code,guess) 
        guess_match_result = @lst_match_result.dup
       	all_code_optns.select! {|x| match?(x,guess,false) || guess_match_result == @lst_match_result} #Simplified implementation of Knuth's Algorithm 
        guess = all_code_optns.sample
        i= i+1
      end 
      print @lst_match_result
    end

    def get_code(reason, *round)    
      puts "#{reason} #{round[0]}\nInsert code as 4 comma separated values from: (B)lue, (G)reen, (O)range, (P)urple, (R)ed, or (Y)ellow."
      code = gets.chomp.upcase.split(",")
      puts "That code is not valid. Please try again!" or code = gets.chomp.upcase.split(",") until code.length ==4 && code.all?{|x| x.match(/[BGOPRY]/)}
      code
    end

    def generate_code
      puts "A.I. has generated a 4-character code from the colours (B)lue, (G)reen, (O)range, (P)urple, (R)ed, and (Y)ellow!\n\n"
      code = Array.new(4){["B","G","O","P","R","Y"].sample}
    end

    def num_to_letter(code)
      out = []
      code.each do |x|
        out.push case x
          when 1 then ("B") 
          when 2 then ("G")
          when 3 then ("O")
          when 4 then ("P") 
          when 5 then ("R") 
          when 6 then ("Y")
        end
      end
      return out
      end

    def match?(code, guess, print=true)
      test_code = code.dup  
      test_guess = guess.dup
      @lst_match_result = {:TM=>0,:CM=>0,:X=>0} #TM = Total Match, CM = Colour match
      
      test_guess.each_with_index {|x,i| test_code[i] = "-" and test_guess[i] = "+" and  @lst_match_result[:TM] +=1 if x == test_code[i]}#Test for exact matches first
         
      test_guess.each_with_index do |x,i|#Test for colour only matches
        if test_code.index(x) then test_code[test_code.index(x)] = "-" and test_guess[i] = "+" and @lst_match_result[:CM] +=1
        elsif x.to_s.match(/[BGOPRY123456789]/) then @lst_match_result[:X] += 1 end
      end
         
      if @lst_match_result[:TM] == 4 #All exact matches
      	puts ". ******** The code was cracked! ********" if print 
      	return true
      else print " which had #{@lst_match_result[:TM]} EXACT MATCHES and #{@lst_match_result[:CM]} COLOUR ONLY MATCHES \n\n" if print end
    end

end#Matermind class end