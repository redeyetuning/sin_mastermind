# ******** MASTERMIND ********
#The codebreaker should try to guess the pattern, in both order and color, within twelve turns. 
#Each guess is made by choosing 4 characters referring to the colours (B)lue, (G)reen, (O)range, (P)urple, (R)ed, or (Y)ellow.  
#Once the guess is place, the codemaker provides feedback by placing from zero to four 'clues' - 
#   - A TOTAL MATCH is displayed for each code character which is of the correct color AND in the correct position. 
#   - A COLOUR MATCH is displayed for each code character which matches a colour in the code but is not in the correct position.
#
#To play use Mastermind.play
 
  
class Mastermind

  def initialize
  
  end
         
    def init_player
      @code = Array.new(4){["B","G","O","P","R","Y"].sample}
      @turns = 12
      @won = false
      #puts "\nYou have 12 guesses to identify the A.I's code. A.I. is generating a code.... \n\n"
      
      #while i<13 && !won
        #return "Your guess was #{guess = get_code("Your Guess", i)}"
        #won = true if match?(@code, guess)
        #i += 1
      #end
      #puts "You ran out of guesses!" if i ==13
    end

    def ai_plays
      i = 1
      won = false
      guess = ["B","G","O","P"] # First guess
      all_code_optns = [*0..5].repeated_permutation(4).to_a.collect{|x| x = num_to_letter(x)} #1296 item array of possible answers 
      @code = get_code("\nChoose your code for the A.I. to guess!")
      puts "\nYou chose #{@code}\n\n"
        
      while i<13 && !won
        print "A.I.'s' guess \##{i} was #{guess}"
        won = true if match?(@code,guess) 
        guess_match_result = @lst_match_result.dup
       	all_code_optns.select! {|x| match?(x,guess,false) || guess_match_result == @lst_match_result} #Simplified implementation of Knuth's Algorithm 
        guess = all_code_optns.sample
        i= i+1
      end 
      print @lst_match_result
    end

    def num_to_letter code
      out = []
      code.each do |x|
        out.push case x
          when 0 then ("B") 
          when 1 then ("G")
          when 2 then ("O")
          when 3 then ("P") 
          when 4 then ("R") 
          when 5 then ("Y")
        end
      end
      return out
      end

    def move guess
      output = match?(guess)
      output += "<h2> ******** The code was cracked! ******** </h2>" if @won
      @turns -= 1
      output += "<h2> ******** You ran out of Moves! ******** </h2>" if @turns == 0
      output
    end

    def match? guess
      test_code = @code.dup
      print test_code  
      test_guess = guess.dup
      @lst_match_result = {:TM=>0,:CM=>0,:X=>0} #TM = Total Match, CM = Colour match
      
      test_guess.each_with_index {|x,i| test_code[i] = "-" and test_guess[i] = "+" and  @lst_match_result[:TM] +=1 if x == test_code[i]}#Test for exact matches first
         
      test_guess.each_with_index do |x,i|#Test for colour only matches
        if test_code.index(x) then test_code[test_code.index(x)] = "-" and test_guess[i] = "+" and @lst_match_result[:CM] +=1
        elsif x.to_s.match(/[BGOPRY0123456789]/) then @lst_match_result[:X] += 1 end
      end
         
      @won =true if @lst_match_result[:TM] == 4 #All exact matches
    	 
      " Your code was #{guess} which had #{@lst_match_result[:TM]} EXACT MATCHES and #{@lst_match_result[:CM]} COLOUR ONLY MATCHES \n\n" 
      
    end

end#Matermind class end