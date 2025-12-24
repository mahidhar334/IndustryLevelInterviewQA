public with sharing class scenarios {
    public static void scenario(list<contact> newCon) {

        list<contact> conList = new list<contact>();
        list<string> conEmail = new list<string>();
        for(contact con : newCon) {
            conEmail.add(con.Email);
        }

        list<contact> conList1 = [select id, email from contact where email in :conEmail];

        for (contact con: newCon){
            if(conList.contains(con.email)){
                con.addError('Email already exists');
            }
        }

    }
}