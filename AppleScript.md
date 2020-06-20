```
on run {input, parameters}
	--set curAPPname to the name of current application
	tell application "Safari"
		activate
		set URL of document 1 to "http://localhost"
	end tell
	--tell application curAPPname to activate
	return input
end run
```


```
on run {input, parameters}
	tell application "Google Chrome"
		activate
		open location "http://localhost"
	end tell
	return input
end run
```

```
on run {input, parameters}
	tell application "Google Chrome"
		activate
		reload
	end tell
	return input
end run
```
