package examples.features.signUp;

import com.intuit.karate.junit5.Karate;

class SignUpRunner {
    
    @Karate.Test
    Karate testSignUp() { return Karate.run("signUp").relativeTo(getClass());}

}
