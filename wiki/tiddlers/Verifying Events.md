When test-driving or just adding tests to an existing class, we often need to verify that an event was raised.
We could try to verify any state changes that the raised event causes, but that's not always easy to achieve when writing unit tests. 
For instance, say we have a class, `MyObservableItem`, that implements `INotifyPropertyChanged`.
We want to raise `PropertyChanged` whenever the `Name` property changes; however, we're test-driving, so we first need to write a test that forces that change in the production code.

```cs
public class MyObservableItem : INotifyPropertyChanged
{
    private int _name;

    public int Name
    {
        get { return _name; }
        set { _name = value; }
    }
    public event PropertyChangedEventHandler PropertyChanged;

    public void OnPropertyChanged([CallerMemberName] string propertyName = "")
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}
```

We could simply attach an event handler and check the result.

```cs
[TestClass]
public class MyObservableItemTest
{
    [TestMethod]
    public void ShouldRaisePropertyChangedForName()
    {
        var item = new MyObservableItem();
        var fired = false;
        item.PropertyChanged += (s, e) => fired = true;

        item.Name = "Steve";

        Assert.IsTrue(fired);
    }
}
```
However, this approach has a few problems.
The test doesn't force `PropertyChanged` to be raised for any particular property (e.g., you could pass the test with `PropertyChanged("steve")`) and it doesn't provide an easy way to check the number of times `PropertyChanged` was invoked.
We could easily add those features by checking `e.PropertyName` and keeping a count; but this isn't very re-usable.
If we had more classes that implemented `INotifyPropertyChanged` and we want to write a similar test, we have to repeat the setup. This quickly becomes tedious.

Instead, we can create a class that will track the number of times `PropertyChanged` is invoked and for which properties.

We'll first need a class to hold the information about our events. Let's call it `EventRecord`.
```cs
public class EventRecord
{
    public int Count { get; set; }

    public bool Fired { get { return Count > 0; } }
}
```

Then we can write a generic class that wraps a `Dictionary` in order to keep track of which properties have raised `PropertyChanged`.

```cs
public class PropertyChangedEventRecorder<T> 
{
    private Dictionary<string, EventRecord> _properties;

    public PropertyChangedEventRecorder(T obj)
    {
        var asInterface = obj as INotifyPropertyChanged;
        if (asInterface == null)
        {
            throw new ArgumentException("Object must implement INotifyPropertyChanged");
        }        
        asInterface.PropertyChanged += TrackPropertyChanged;

        _properties = new Dictionary<string, EventRecord>();
    }

    private void TrackPropertyChanged(object sender, PropertyChangedEventArgs e)
    {
        var propertyName = e.PropertyName;

        if (_properties.ContainsKey(propertyName))
        {
            _properties[propertyName].Count++;
        } else
        {
            _properties[propertyName] = new EventRecord() { Count = 1 };
        }
    }

    public EventRecord this[string propertyName]
    {
        get
        {
            return _properties.ContainsKey(propertyName)
                ? _properties[propertyName] : new EventRecord();
        }
    }
}
```

If we also implement an [`indexer`](https://msdn.microsoft.com/en-us/library/2549tw02.aspx) for the class, we can write assertions like the following:

```cs
[TestMethod]
public void ShouldRaisePropertyChangedForName()
{
    var item = new MyObservableItem();
    var eventRecorder = new PropertyChangedEventRecorder<MyObservableItem>(item);

    item.Name = "Steve";
    item.Name = "Bob";
    item.Name = "Stacy";

    Assert.IsTrue(eventRecorder[nameof(item.Name)].Fired);
    Assert.AreEqual(3, eventRecorder[nameof(item.Name)].Count);
}
```
So now we have an easy, re-usable way to assert that `PropertyChanged` was raised.
For this simple example, it doesn't get us a whole lot; however, if we had several calculated properties bound to a single backing field, it would be much easier to verify that `PropertyChanged` was raised for each one.