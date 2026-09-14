package com.fpt.controller;

import com.fpt.entity.Contact;
import com.fpt.service.ContactService;
import java.util.List;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/contacts")
public class ContactController {

    private final ContactService service;

    public ContactController(ContactService contactService) {
        this.service = contactService;
    }

    @GetMapping
    public List<Contact> getAllContacts() {
        return service.getAllContacts();
    }

    @PostMapping
    public Contact createContact(@RequestBody Contact contact) {
        return service.createContact(contact);
    }

    @PutMapping("/{id}")
    public Contact updateContact(
            @PathVariable Integer id,
            @RequestBody Contact contact) {

        return service.updateContact(id, contact);
    }

    @DeleteMapping("/{id}")
    public void deleteContact(@PathVariable Integer id) {
        service.deleteContact(id);
    }

    @GetMapping("/search")
    public List<Contact> searchContacts(@RequestParam String keyword) {
        return service.searchContacts(keyword);
    }
}