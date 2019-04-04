function check(event) {
	// Get Values
	var matric  = document.getElementById('email' ).value;
	var name    = document.getElementById('username'   ).value;
	var faculty = document.getElementById('password').value;
	
	// Simple Check
	if(matric.length == 0) {
		alert("Invalid matric number");
		event.preventDefault();
		event.stopPropagation();
		return false;
	}
	if(name.length == 0) {
		alert("Invalid name");
		event.preventDefault();
		event.stopPropagation();
		return false;
	}
	if(passeword.length == 0) {
		alert("Invalid password code");
		event.preventDefault();
		event.stopPropagation();
		return false;
	}
}