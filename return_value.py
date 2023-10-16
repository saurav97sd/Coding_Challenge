# First we will initialize the nested object and the key
obj = {"x":{"y":{"z":"a"}}}
key = "x/y/z"

def return_value(obj1, key1):
    keys = key1.split('/') # We are making a list of keys using split method which split string into a list
    value = obj1

    # Now we will itirate in the list of keys to get value for each key until the last key
    for i in keys:
        # checking if the key (i) is present in the nested object
        if i in value:
            value = value[i] # substituting the value for the key
        else:
            return None
    
    # Returning final value
    return value


# Checking the result by calling the function we created above
result = return_value(obj, key)

# Printing result
print(f"Expected value for the following key '{key}' is '{result}'")