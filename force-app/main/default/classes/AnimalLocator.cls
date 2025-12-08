public class AnimalLocator {
    public static String getAnimalNameById(Integer id){
        String animalName = '';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals/' + id);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setMethod('GET');
        HttpResponse response = http.send(request);        
        if(response.getStatusCode() == 200) {        
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());            
             // Cast the values in the 'animals' key as a list
            Map<String, Object> animal = (Map<String, Object>) results.get('animal');
            if(animal != null && animal.containsKey('name')) {
                animalName = (String) animal.get('name');
            }
        }
        return animalName;
    }
}