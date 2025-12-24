public  without sharing class contactClass {
    
    public static void duplicateEmailValidation(List<contact> newConlist){
        set<String> emailSet = new set<String>();
        for(contact con : newConlist){
            if(con.email != NUll){
                emailSet.add(con.email);
            }
        }
        
         Map<String,Contact> conMap = new Map<String,Contact>();
        List<Contact> exsitingContacts =[select id,email from contact where email in: emailSet];
        for(contact con :exsitingContacts){
            conMap.put(con.email , con);
        }
       
        
         for(contact con : newConlist){
             if(con.email != null && conMap.containskey(con.email)){
                 con.adderror('contact cannot be created');
             }
             
         }
        
        
        
    }

}