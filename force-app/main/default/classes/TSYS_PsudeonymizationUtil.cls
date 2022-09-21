
/**
 * @Company : T Systems
 * @Purpose : Provides Psudeonymization functionality. Used in Account Trigger
 ********************************* Modification Log *****************************************************
  Modified By                       Modified on             Ticket No.                    Comments
  Bhushan Patil                     10-08-2022               xxxxxx                    initial version                                                                                only consider scheduled or dispatched services
 **/ 
public class TSYS_PsudeonymizationUtil {

    /**
    * @description It psudeonymizes the input string in such a way that all the letters are swapped instead of the first and last letter 
    * @param inputString Given input string to be psudeonymized
    * @return psudeonymized String 
    */
    public static String generate(String inputString) {
        String psudeonymizedString = '';
        //-- convert each word seperately
        for(String word : inputString.split(' ')){
            psudeonymizedString += convert(word)+' ';
        }
        //-- remove the space at the end
        psudeonymizedString = psudeonymizedString.trim(); 
        return psudeonymizedString;
    }

    private static String convert(String inputString){
        List<Integer> numbersArray = inputString.getChars();
        List<Integer> output = new List<integer>{numbersArray[0]};
        while(numbersArray.size() > 2 ){
            Integer randomIndex = getRandomNumber(1, numbersArray.size() - 2);
            output.add(numbersArray[randomIndex]);
            numbersArray.remove(randomIndex);
        }
        output.add(numbersArray[numbersArray.size()-1]);
        return String.fromCharArray(output);

    }

    private static Integer getRandomNumber(Integer min, Integer max) {
        Integer totalElements = max - min + 1;
        Integer result = (Integer)Math.floor(Math.random() * totalElements) + min;
        return result;
    }

}
