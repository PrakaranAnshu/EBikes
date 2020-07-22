public with sharing class ProductController {
    
    static integer PAGE_SiZE=4;
    //setting up the getters and setters for the filetrs
    public class Filters{
        @AuraEnabled
        public string searchKey{get;set;}
        @AuraEnabled
        public Decimal maxPrice{get;set;}
        @AuraEnabled
        public String[] categories{get;set;}
        @AuraEnabled
        public String[] materials{get;set;}
        @AuraEnabled
        public String[] levels{get;set;}
    }

    @AuraEnabled(Cacheable= true)
    public static PagedResult getProducts(Filters filetrs, Integer pageNumber){
        String key;
        String whereClause= '';
        Decimal maxPrice;
        String[] categories;
        String[] materials;
        String[] levels;
        String[] criteria= new List<String>();
        if(filetrs != null){
            maxPrice= filetrs.maxPrice;
            materials= filetrs.materials;
            levels= filetrs.levels;
            if(!String.isEmpty(filetrs.searchKey)){
                key= '%'+filetrs.searchKey+'%';
                criteria.add('Name LIKE: key');
            }
            if(filetrs.maxPrice >= 0){
                maxPrice= filetrs.maxPrice;
                criteria.add('MSRP__c <= :maxPrice');
            }
            if(filetrs.categories != null){
                categories= filetrs.categories;
                criteria.add('Category__c IN :categories');
            }
            if(filetrs.levels != null){
                levels= filetrs.levels;
                criteria.add('Level__c IN :levels');
            }
            if(filetrs.materials != null){
                materials= filetrs.materials;
                criteria.add('Material__c IN :materials');
            }
            if(criteria.size() >0){
                whereClause= 'WHERE'+ String.join(criteria, 'AND');
            }
        }
        Integer pageSize= ProductController.PAGE_SiZE;
        Integer offSet= (pageNumber-1)*pageSize;
        PagedResult result= new PagedResult();
        result.pageSize= pageSize;
        result.pageNumber= pageNumber;
        result.totalItemCount= Database.countQuery('select count() from Product__c'+whereClause);
        result.records = Database.query(
            'SELECT Id, Name, MSRP__c, Description__c, Category__c, Level__c, Picture_URL__c, Material__c FROM Product__c ' +
            whereClause +
            ' ORDER BY Name LIMIT :pageSize OFFSET :offset'
        );
        return result;

        
    }
}
