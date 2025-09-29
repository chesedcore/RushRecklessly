class_name CountedLock extends Resource

var locks: int = 0
var name: String

func _init(with_name: String = "GenericLock") -> void:
	self.name = with_name

func is_malformed() -> bool:
	return locks < 0

func is_unlocked() -> bool:
	return locks == 0

func add_lock(amount: int = 1) -> void:
	assert(not is_malformed(), "This lock has been malformed. Check improper adds/removes.")
	locks += amount

func remove_lock(amount: int = 1) -> void:
	assert(not is_malformed(), "This lock has been malformed. Check improper adds/removes.")
	locks -= amount

func _to_string() -> String:
	return "CountedLock<"+name+": "+str(locks)+">"
