// ActionScript file

[Test]
public function testThat_clone_works():void {
	var actual:Object = sut.clone() as cloneTestType;
	assertTrue(actual is cloneTestType);
}