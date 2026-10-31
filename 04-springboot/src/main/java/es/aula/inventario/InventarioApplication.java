package es.aula.inventario;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class InventarioApplication {

    public static void main(String[] args) {
        SpringApplication.run(InventarioApplication.class, args);
    }

    /** Carga tres dispositivos de ejemplo la primera vez que arranca con la base de datos vacía. */
    @Bean
    CommandLineRunner datosIniciales(DispositivoRepository repo) {
        return args -> {
            if (repo.count() == 0) {
                repo.save(new Dispositivo("puesto01", "taller1", "estacion"));
                repo.save(new Dispositivo("puesto02", "taller1", "estacion"));
                repo.save(new Dispositivo("horno-a", "nave2", "termopar"));
            }
        };
    }
}
