package com.fpt.service;

import com.fpt.entity.Contact;
import java.util.List;

/**
 *
 * @author Lenhan
 */
public interface ContactService {

    List<Contact> getAllContacts();

    Contact createContact(Contact contact);

    Contact updateContact(Integer id, Contact contact);

    void deleteContact(Integer id);

    List<Contact> searchContacts(String keyword);
}
