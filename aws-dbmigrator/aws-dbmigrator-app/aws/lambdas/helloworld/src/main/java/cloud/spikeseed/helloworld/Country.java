package cloud.spikeseed.helloworld;

public class Country {
	private String alpha2;
	private String alpha3;
	private String name;

	public Country(String alpha2, String alpha3, String name) {
		this.alpha2 = alpha2;
		this.alpha3 = alpha3;
		this.name = name;
	}

	public String getAlpha2() {
		return alpha2;
	}

	public String getAlpha3() {
		return alpha3;
	}

	public String getName() {
		return name;
	}
}
