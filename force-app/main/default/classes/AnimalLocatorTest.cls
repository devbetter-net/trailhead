@isTest
public with sharing class AnimalLocatorTest {
    public AnimalLocatorTest() {

    }



    @isTest
    static void testAnimalLocator() {
        Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock());
        String animalName = AnimalLocator.getAnimalNameById(1);
        System.Assert.areEqual('chicken', animalName);
    }
}