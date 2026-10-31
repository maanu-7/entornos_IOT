package es.aula.inventario;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/dispositivos")
public class DispositivoController {

    private final DispositivoRepository repo;

    public DispositivoController(DispositivoRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<Dispositivo> listar() {
        return repo.findAll();
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public Dispositivo crear(@RequestBody Dispositivo nuevo) {
        return repo.save(nuevo);
    }
}
