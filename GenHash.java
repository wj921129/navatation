import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordGen {
    public static void main(String[] args) {
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
        System.out.println("HASH_START");
        System.out.println(encoder.encode("admin123"));
        System.out.println("HASH_END");
    }
}
