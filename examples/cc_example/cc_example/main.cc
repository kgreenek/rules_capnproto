#include <iostream>

#include "capnp/message.h"
#include "capnp/pretty-print.h"

#include "cc_example/capnp/address_book.capnp.h"

int main(int argc, char** argv) {
  ::capnp::MallocMessageBuilder message;

  ::cc_example::capnp::AddressBook::Builder address_book =
      message.initRoot<::cc_example::capnp::AddressBook>();
  ::capnp::List<::cc_example::capnp::Person>::Builder people = address_book.initPeople(2);

  ::cc_example::capnp::Person::Builder alice = people[0];
  alice.setId(123);
  alice.setName("Alice");
  alice.setEmail("alice@example.com");
  // Type shown for explanation purposes; normally you'd use auto.
  ::capnp::List<::cc_example::capnp::Person::PhoneNumber>::Builder alice_phones = alice.initPhones(1);
  alice_phones[0].setNumber("555-1212");
  alice_phones[0].setType(::cc_example::capnp::Person::PhoneNumber::Type::MOBILE);
  alice.getEmployment().setSchool("MIT");

  ::cc_example::capnp::Person::Builder bob = people[1];
  bob.setId(456);
  bob.setName("Bob");
  bob.setEmail("bob@example.com");
  auto bobPhones = bob.initPhones(2);
  bobPhones[0].setNumber("555-4567");
  bobPhones[0].setType(::cc_example::capnp::Person::PhoneNumber::Type::HOME);
  bobPhones[1].setNumber("555-7654");
  bobPhones[1].setType(::cc_example::capnp::Person::PhoneNumber::Type::WORK);
  bob.getEmployment().setUnemployed();

  std::cout << ::capnp::prettyPrint(address_book).flatten().cStr() << std::endl;
  return 0;
}
