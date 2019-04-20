```csharp
[Test]
public void ShouldDoSomething()
{
    var expectedProperty = "Anything";
    Predicate<MyType> myTypeMatcher = (
        myType => myType.MyProperty == expectedProperty
    );
    
    _serviceMock.Setup(
        service => service.DoThing(Match.Create(myTypeMatcher)));
    
    var actual = _systemUnderTest.ThingThatUsesService();
    
    Assert.IsTrue(true);
}
```