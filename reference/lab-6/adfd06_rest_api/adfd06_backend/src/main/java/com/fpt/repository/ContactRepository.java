package com.fpt.repository;
import com.fpt.entity.Contact;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 *
 * @author Lenhan
 */
public interface ContactRepository extends JpaRepository<Contact, Integer>  {
    
    List<Contact> findByNameContainingIgnoreCase(String keyword);
    
}
