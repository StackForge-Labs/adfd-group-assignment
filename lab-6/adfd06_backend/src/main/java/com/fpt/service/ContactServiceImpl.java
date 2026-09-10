package com.fpt.service;

import com.fpt.entity.Contact;
import com.fpt.repository.ContactRepository;
import java.util.List;
import org.springframework.stereotype.Service;

/**
 *
 * @author Lenhan
 */
//@RequiredArgsConstructor
@Service
public class ContactServiceImpl implements ContactService {

    private final ContactRepository repo;

    public ContactServiceImpl(ContactRepository contactRepository) {
        this.repo = contactRepository;
    }

    @Override
    public List<Contact> getAllContacts() {
        return repo.findAll();
    }

    @Override
    public Contact createContact(Contact contact) {
        return repo.save(contact);
    }

    @Override
    public Contact updateContact(Integer id, Contact contact) {

        Contact current = repo.findById(id)
                .orElseThrow(() -> new RuntimeException(
                        "Contact not found: " + id
                ));

        current.setName(contact.getName());
        current.setEmail(contact.getEmail());
        current.setPhone(contact.getPhone());
        current.setAddress(contact.getAddress());

        return repo.save(current);
    }

    @Override
    public void deleteContact(Integer id) {
        repo.deleteById(id);
    }

    @Override
    public List<Contact> searchContacts(String keyword) {
        return repo.findByNameContainingIgnoreCase(keyword);
    }
}
