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
    @turns = 1
    @won = false
    @guess_peg_cols = []
    @cor_peg_cols =[]
  end
         
  def init_player
    @code = Array.new(4){["blue","green","orange","purple","red","yellow"].sample}
  end

  def ai_plays code
    @code = code
    all_code_optns = ["blue","green","orange","purple","red","yellow"].repeated_permutation(4).to_a#1296 item array of possible answers 
    guess = ["blue","green","orange","purple"] # First guess
    won = false
    output =""
         
    while @turns <13 && !won
      won =true && output = guess if match?(@code,guess) == true  
      guess.each{|x| @guess_peg_cols << x}
      guess_match_result = @lst_match_result.dup
     	all_code_optns.select! {|x| match?(x,guess,false) == true || guess_match_result == @lst_match_result} #Simplified implementation of Knuth's Algorithm 
      guess = all_code_optns.sample
      @turns += 1
    end 
    "</br><h3>**AI found your code in #{13-@turns} turns!**</h3> <p>Your game has ended - please return to the <a class = 'inline' href='../'>main menu</a> to start a new game</p>"
  end

  def peg_cols(item)
    item == "guess" ? cols = @guess_peg_cols : cols = @cor_peg_cols
    output = cols.each_with_index.map{|x,i|"##{item}-peg#{i+1}{background-color:#{x}; #{"box-shadow: 2px 2px 2px rgba(0, 0, 0, 0.59)" unless x.nil?};} "}.join
  end

  def move guess
    if @turns == 13
      output = "<p>Your game has ended - please return to the <a class = 'inline' href='../'>main menu</a> to start a new game</p>"
    else  
      guess.each{|x| @guess_peg_cols << x}
      output = match?(@code, guess)
      output += "</br><h3>******** The code was cracked! ********</h3>" && @turns = 13 if @won
      @turns += 1
      output += "</br><h3>******** You ran out of Moves! ********</h3>" if @turns == 13
    end
    output
  end

  def match? code, guess, col=true
    test_code = code.dup
    print test_code  
    test_guess = guess.dup
    @lst_match_result = {:TM=>0,:CM=>0,:X=>0} #TM = Total Match, CM = Colour match
    
    test_guess.each_with_index {|x,i| test_code[i] = "-" and test_guess[i] = "+" and  @lst_match_result[:TM] +=1 if x == test_code[i]}#Test for exact matches first
       
    test_guess.each_with_index do |x,i|#Test for colour only matches
      if test_code.index(x) then test_code[test_code.index(x)] = "-" and test_guess[i] = "+" and @lst_match_result[:CM] +=1 end
    end
       
    
    if col
      (@lst_match_result[:TM]).times { @cor_peg_cols << "black"}
      (@lst_match_result[:CM]).times { @cor_peg_cols << "white"}
      (4-@lst_match_result[:TM]-@lst_match_result[:CM]).times { @cor_peg_cols << nil} 
    end
    
    if @lst_match_result[:TM] == 4 #All exact matches
      @won = true
      true
    else
      "Your guess had #{@lst_match_result[:TM]} EXACT MATCHES and #{@lst_match_result[:CM]} COLOUR ONLY MATCHES \n\n" 
    end
  end

end#Matermind class end